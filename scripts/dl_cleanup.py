#!/usr/bin/env python
"""
# OpenWRT download directory cleanup utility.
# Delete all but the very last version of the program tarballs.
#
# Copyright (c) 2010 Michael Buesch <mb@bu3sch.de>
"""

import sys
import os
import re
import getopt

# Commandline options
opt_dryrun = False


def parseVer_1234(match):
	progname = match.group(1)
	progversion = (int(match.group(2)) << 64) |\
		      (int(match.group(3)) << 48) |\
		      (int(match.group(4)) << 32) |\
		      (int(match.group(5)) << 16)
	return (progname, progversion)

def parseVer_123(match):
	progname = match.group(1)
	try:
		patchlevel = match.group(5)
	except (IndexError), e:
		patchlevel = None
	if patchlevel:
		patchlevel = ord(patchlevel[0])
	else:
		patchlevel = 0
	progversion = (int(match.group(2)) << 64) |\
		      (int(match.group(3)) << 48) |\
		      (int(match.group(4)) << 32) |\
		      patchlevel
	return (progname, progversion)

def parseVer_12(match):
	progname = match.group(1)
	try:
		patchlevel = match.group(4)
	except (IndexError), e:
		patchlevel = None
	if patchlevel:
		patchlevel = ord(patchlevel[0])
	else:
		patchlevel = 0
	progversion = (int(match.group(2)) << 64) |\
		      (int(match.group(3)) << 48) |\
		      patchlevel
	return (progname, progversion)

def parseVer_r(match):
	progname = match.group(1)
	progversion = (int(match.group(2)) << 64)
	return (progname, progversion)

def parseVer_ymd(match):
	progname = match.group(1)
	progversion = (int(match.group(2)) << 64) |\
		      (int(match.group(3)) << 48) |\
		      (int(match.group(4)) << 32)
	return (progname, progversion)

extensions = (
	".tar.gz",
	".tar.bz2",
	".orig.tar.gz",
	".orig.tar.bz2",
	".zip",
	".tgz",
	".tbz",
)

versionRegex = (
	(re.compile(r"(.+)[-_](\d+)\.(\d+)\.(\d+)\.(\d+)"), parseVer_1234),	# xxx-1.2.3.4
	(re.compile(r"(.+)[-_](\d\d\d\d)-?(\d\d)-?(\d\d)"), parseVer_ymd),	# xxx-YYYY-MM-DD
	(re.compile(r"(.+)[-_](\d+)\.(\d+)\.(\d+)(\w?)"), parseVer_123),	# xxx-1.2.3a
	(re.compile(r"(.+)[-_](\d+)_(\d+)_(\d+)"), parseVer_123),		# xxx-1_2_3
	(re.compile(r"(.+)[-_](\d+)\.(\d+)(\w?)"), parseVer_12),		# xxx-1.2a
	(re.compile(r"(.+)[-_]r?(\d+)"), parseVer_r),				# xxx-r1111
)

blacklist = [
	("linux",		re.compile(r"linux-.*")),
	("gcc",			re.compile(r"gcc-.*")),
	("wl_apsta",		re.compile(r"wl_apsta.*")),
	(".fw",			re.compile(r".*\.fw")),
	(".arm",		re.compile(r".*\.arm")),
	(".bin",		re.compile(r".*\.bin")),
	("rt-firmware",		re.compile(r"RT[\d\w]+_Firmware.*")),
]

class EntryParseError(Exception): pass

class Entry:
	def __init__(self, directory, filename):
		self.directory = directory
		self.filename = filename
		self.progname = ""

		for ext in extensions:
			if filename.endswith(ext):
				filename = filename[0:0-len(ext)]
				break
		else:
			print self.filename, "has an unknown file-extension"
			raise EntryParseError("ext")
		for (regex, parseVersion) in versionRegex:
			match = regex.match(filename)
			if match:
				(self.progname, self.version) = parseVersion(match)
				break
		else:
			print self.filename, "has an unknown version pattern"
			raise EntryParseError("ver")

	def deleteFile(self):
		path = (self.directory + "/" + self.filename).replace("//", "/")
		print "Deleting", path
		if not opt_dryrun:
			os.unlink(path)

	def __eq__(self, y):
		return self.filename == y.filename

	def __ge__(self, y):
		return self.version >= y.version

def usage():
	print "OpenWRT download directory cleanup utility"
	print "Usage: " + sys.argv[0] + " [OPTIONS] <path/to/dl>"
	print ""
	print " -d|--dry-run            Do a dry-run. Don't delete any files"
	print " -B|--show-blacklist     Show the blacklist and exit"
	print " -w|--whitelist ITEM     Remove ITEM from blacklist"

def main(argv):
	global opt_dryrun

	try:
		(opts, args) = getopt.getopt(argv[1:],
			"hdBw:",
			[ "help", "dry-run", "show-blacklist", "whitelist=", ])
		if len(args) != 1:
			usage()
			return 1
	except getopt.GetoptError:
		usage()
		return 1
	directory = args[0]
	for (o, v) in opts:
		if o in ("-h", "--help"):
			usage()
			return 0
		if o in ("-d", "--dry-run"):
			opt_dryrun = True
		if o in ("-w", "--whitelist"):
			for i in range(0, len(blacklist)):
				(name, regex) = blacklist[i]
				if name == v:
					del blacklist[i]
					break
			else:
				print "Whitelist error: Item", v,\
				      "is not in blacklist"
				return 1
		if o in ("-B", "--show-blacklist"):
			for (name, regex) in blacklist:
				print name
			return 0

	# Create a directory listing and parse the file names.
	entries = []
	for filename in os.listdir(directory):
		if filename == "." or filename == "..":
			continue
		for (name, regex) in blacklist:
			if regex.match(filename):
				if opt_dryrun:
					print filename, "is blacklisted"
				break
		else:
			try:
				entries.append(Entry(directory, filename))
			except (EntryParseError), e: pass

	# Create a map of programs
	progmap = {}
	for entry in entries:
		if entry.progname in progmap.keys():
			progmap[entry.progname].append(entry)
		else:
			progmap[entry.progname] = [entry,]

	# Traverse the program map and delete everything but the last version
	for prog in progmap:
		lastVersion = None
		versions = progmap[prog]
		for version in versions:
			if lastVersion is None or version >= lastVersion:
				lastVersion = version
		if lastVersion:
			for version in versions:
				if version != lastVersion:
					version.deleteFile()
			if opt_dryrun:
				print "Keeping", lastVersion.filename

	return 0

if __name__ == "__main__":
	sys.exit(main(sys.argv))
