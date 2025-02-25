from pypinyin import lazy_pinyin
import sys
from multiprocessing import Pool
from tqdm import tqdm

import sys


def read(line):
    line = line.strip("\n")
    # skip blank and broken lines

    tokens_and_tags = [pair.rsplit('SEPL|||SEPR', 1)
                       for pair in line.split(' ')]
    try:

        tags = [tag for token, tag in tokens_and_tags]
    except ValueError:
            tokens = [token for token, tag in tokens_and_tags]
            tags = [tag for token, tag in tokens_and_tags]

    # words = [x.text for x in tokens]

   # tag = self.extract_tags(tags)
    tags.pop(0)
    tag=''
    for label in tags:
        if 'KEEP' in label:
            tag=tag+' '+'0'
#        else:
    #    else:
      #      tag=tag+' '+'1'
        elif 'APPEND' in label:
            tag=tag+' '+'1'
      #  elif "DELETE" in label:
      #      tag = tag + ' ' + '2'
      #  else:
      #      tag = tag +' ' +'3'

    tag=tag+' '+'2'
    return tag




with Pool(64) as pool:
    for ret in pool.imap(read, tqdm(sys.stdin), chunksize=1024):
        print(ret)
