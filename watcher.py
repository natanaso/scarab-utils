#!/usr/bin/python
import os
import hashlib
import sys
import time

def digest_file(path):
    try:
        sh = hashlib.sha1()
        with open(path) as f:
            for line in f:
                sh.update(line)                
    except IOError, ex:
        return None

    return sh.digest()

def snapshot(path):
    transform = {} # file path relative to path -> Node
    if os.path.isdir(path):
        for dirpath, dirnames, fnames in os.walk(path):
            rm = [i for i,x in enumerate(dirnames) if '.git' in x]
            for i in rm:
                del dirnames[i]

            for fname in fnames:
                fpath = os.path.join(dirpath, fname)
                frel = os.path.join(*fpath.split(os.sep)[1:])

                digest = digest_file(fpath)
                if digest is not None:
                    transform[frel] = digest
    elif os.path.isfile(path):
        transform[path] = digest_file(path)

    return transform

def watch(path):
    state = snapshot(path)


    while True:
        start = time.time()        
        new_state = snapshot(path)
        
        if state != new_state:
            s_keys = set(state.keys())
            ns_keys = set(new_state.keys())

            removed = s_keys.difference(ns_keys)
            added = ns_keys.difference(s_keys)
            same = s_keys.intersection(ns_keys)
            modified = [path for path in same if new_state[path] != state[path]]
            
            if added:
                print "The following files were added: %s" % added
            if removed:
                print "The following files were removed: %s" % removed
            if modified:
                print "The following files were modified: %s" % modified
            
            break
        print time.time() - start
        time.sleep(0.2)
    print "Change!"
        
if __name__ == "__main__":
    watch(sys.argv[1])
