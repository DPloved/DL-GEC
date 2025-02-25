import sys

def is_chinese_char(uchar):
    """判断一个unicode是否是汉字"""
    return '\u4e00' <= uchar <= '\u9fa5'



input_file = sys.argv[1]
cor_file = sys.argv[2]
id_file = sys.argv[3]
out_file = sys.argv[4]
length = int(sys.argv[5])
f3 = open(id_file,'r')
with open(input_file, "r",encoding='utf8') as f1:
    with open(cor_file, "r",encoding='utf8') as f2:
        with open(out_file, "w",encoding='utf8') as o:
            srcs, tgts,ids = f1.readlines(), f2.readlines(),f3.readlines()
          #  ids =[id for id in range(len(srcs))]
            res_li = ["" for i in range(length)]
            for src, tgt, idx in zip(srcs, tgts, ids):
                if '<unk>' in tgt:
                    src = src.replace('##', '')
                    tgt = tgt.replace('##', '')
                    #src = src.replace('#', '')
                    #tgt = tgt.replace('#', '')


                    src_lis=src.split()
                    tgt_lis=tgt.split()
                    con = 0
                    for id,char in enumerate(tgt_lis):
                        con_char=''
                        if '<unk>'==char:
                            flag=False
                            sen=con
                            for src_char in src_lis[con:]:
                                sen += 1
                                if not is_chinese_char(src_char) and src_char not in tgt:
                                    con_char+=src_char
                                    flag=True
                                    continue
                                elif flag:
                                    con=sen
                                    break
                            tgt_lis[id]=con_char
                    src=''.join(src_lis)
                    tgt=''.join(tgt_lis)
                else:
                    src=src.replace(' ','').replace('##','')
                    tgt = tgt.replace(' ', '').replace('##', '')
                if len(src) >= 128 or len(tgt) >= 128:
                    res = src
                else:
                    res = tgt
                res = res.rstrip("\n")
                res_li[int(idx)] += res
            for res in res_li:
                o.write(res + "\n")
