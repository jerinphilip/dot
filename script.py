#!/usr/bin/python2

import yaml
import sys
import subprocess as sp
import datetime

stream = open("config.yml", "r")
options = yaml.load(stream)
existing = options["existing"]

def backup(command, local, actual):
    cmdList = command + [actual, local]
    sp.Popen(cmdList).wait()

def restore(command, local, actual):
    cmdList = command + [local, actual]
    #print(' '.join(cmdList))
    sp.Popen(cmdList).wait()

def git_update():
    timestamp = '"'+str(datetime.datetime.utcnow())+'"'
    cmds = [
        ['git', 'add', '-A'],
        ['git', 'commit', '-m', timestamp],
        ['git', 'push', '-u', 'github', 'master']
    ]
    for cmd in cmds:
        sp.Popen(cmd).wait()

if len(sys.argv) < 2:
    print("usage %s backup|restore"%(sys.argv[0]))
else:
    d = {"backup": backup, "restore": restore}
    if sys.argv[1] in ["backup", "restore"]:
        f = d[sys.argv[1]]
        for level in existing.keys():
            level_dict = existing[level]
            for ftype in level_dict.keys():
                if level_dict[ftype]:
                    for data in level_dict[ftype]:
                        for local in data.keys():
                            command = []
                            if level == "protected": command.append("sudo")
                            command.append("cp")
                            if ftype == "files": command.append("-v")
                            else: command.append("-rv")
                            f(command, local, data[local])
                print("")
        if sys.argv[1] == "backup":
            git_update()
        
    else:
        print("usage %s backup|restore"%(sys.argv[0]))

