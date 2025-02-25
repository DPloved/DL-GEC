from pypinyin import lazy_pinyin,Style
import sys
from multiprocessing import Pool
from tqdm import tqdm
def is_chinese_char(uchar):
    """判断一个unicode是否是汉字"""
    return '\u4e00' <= uchar <= '\u9fa5'
def is_all_num(uchar):
    return all(is_number(c) for c in uchar)


def is_alphabet(uchar):
    """判断一个unicode是否是英文字母"""
    return '\u0041' <= uchar <= '\u005a' or '\u0061' <= uchar <= '\u007a'

def is_number(uchar):
    """判断一个unicode是否是数字"""
    return '\u0030' <= uchar <= '\u0039'

def is_alphabet_string(string):
    """判断是否全部为英文字母"""
    return all(is_alphabet(c) for c in string)

def is_other(uchar):
    """判断是否非汉字，数字和英文字符"""
    return not (is_chinese_char(uchar) or is_number(uchar) or is_alphabet(uchar))

def is_alphabet_number_string(string):
    """判断全是数字和英文字符"""
    return all((is_alphabet(c) or is_number(c)) for c in string)

pin_dict={}
di=open('./pin_vocab.txt1','r')
for idx,line in enumerate(di):
    pin_dict[line.strip('\n')]=idx
length=len(pin_dict)


def make_pinyin(line):
    write_line =""
    lis=line.split(' ')
    for char in lis:
        if is_chinese_char(char):
            pinyin = lazy_pinyin(char,style=Style.TONE3)
            if pinyin[0]=='n2':
                pinyin=['en2']
            try:
                pinyin = str(pin_dict[pinyin[0]])
            except:
                print(char)
                print(pinyin)
        else:
            char=char.replace('##','')
            if is_alphabet_string(char):
                pinyin=str(length)
            elif is_all_num(char):
                pinyin=str(length+1)
            elif is_alphabet_number_string(char):
                pinyin = str(length+2)
            else:
                pinyin = str(length+3)
        if isinstance(pinyin,list):
            print(pinyin)
        write_line=write_line+pinyin+' '
    write_line=write_line+str(length+4)
    assert len(write_line.strip().split(' '))==len(lis)+1
    return write_line


with Pool(64) as pool:
    for ret in pool.imap(make_pinyin, tqdm(sys.stdin), chunksize=1024):
        print(ret)
