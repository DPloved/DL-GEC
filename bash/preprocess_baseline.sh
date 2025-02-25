####################
# Preprocess HSK+Lang8
####################

FAIRSEQ_DIR=../../src/src_dlgec/fairseq-0.10.2/fairseq_cli
PROCESSED_DIR=../../preprocess/chinese_baseline

WORKER_NUM=64
DICT_SIZE=32000
TRAIN_FILE=/home/shared/data/zh_data/lang8+hsk/train_data/train
VALID_FILE=/home/shared/data/zh_data/MuCGEC/dev


TRAIN_SRC_FILE=$TRAIN_FILE".src"
TRAIN_TGT_FILE=$TRAIN_FILE".tgt"
TRAIN_LABEL=$TRAIN_FILE".label"
VALID_SRC_FILE=$VALID_FILE".src"
VALID_TGT_FILE=$VALID_FILE".tgt"
VALID_LABEL=$VALID_FILE".label"

# apply char

python ../../utils/segment_bert.py <$TRAIN_SRC_FILE >$TRAIN_SRC_FILE".char"
python ../../utils/segment_bert.py <$TRAIN_TGT_FILE >$TRAIN_TGT_FILE".char"
python ../../utils/segment_bert.py <$VALID_SRC_FILE >$VALID_SRC_FILE".char"
python ../../utils/segment_bert.py <$VALID_TGT_FILE >$VALID_TGT_FILE".char"

#make detect tag
python ../../utils/preprocess_data.py -s $VALID_SRC_FILE".char" -t $VALID_TGT_FILE".char" -o $VALID_LABEL --worker_num 64
python ../../utils/preprocess_data.py -s $TRAIN_SRC_FILE".char" -t $TRAIN_TGT_FILE".char" -o $TRAIN_LABEL --worker_num 64
python ../../utils/make_tag.py <$TRAIN_LABEL >$TRAIN_FILE".tag"
python ../../utils/make_tag.py <$VALID_LABEL >$VALID_FILE".tag"
#make pinyin tag

python ../../utils/make_pinyin_tag.py <$TRAIN_SRC_FILE".char" >$TRAIN_FILE".pinyin.tag"
python ../../utils/make_pinyin_tag.py <$VALID_SRC_FILE".char" >$VALID_FILE".pinyin.tag"




# fairseq preprocess
mkdir -p $PROCESSED_DIR
cp $TRAIN_SRC_FILE $PROCESSED_DIR/train.src
cp $TRAIN_SRC_FILE".char" $PROCESSED_DIR/train.char.src
cp $TRAIN_TGT_FILE $PROCESSED_DIR/train.tgt
cp $TRAIN_TGT_FILE".char" $PROCESSED_DIR/train.char.tgt
cp $VALID_SRC_FILE $PROCESSED_DIR/valid.src
cp $VALID_SRC_FILE".char" $PROCESSED_DIR/valid.char.src
cp $VALID_TGT_FILE $PROCESSED_DIR/valid.tgt
cp $VALID_TGT_FILE".char" $PROCESSED_DIR/valid.char.tgt
cp $VALID_FILE".tag" $PROCESSED_DIR/valid.tag
cp $TRAIN_FILE".tag" $PROCESSED_DIR/train.tag
cp $VALID_FILE".pinyin.tag" $PROCESSED_DIR/valid.pinyin.tag
cp $TRAIN_FILE".pinyin.tag" $PROCESSED_DIR/train.pinyin.tag




echo "Preprocess..."

mkdir -p $PROCESSED_DIR/lang8

python $FAIRSEQ_DIR/preprocess.py --source-lang src --target-lang tgt \
       --user-dir ../../src/src_dlgec/dlgec_model \
       --task dltax-enhanced-translation \
       --trainpref $PROCESSED_DIR/train.char \
       --validpref $PROCESSED_DIR/valid.char \
       --destdir $PROCESSED_DIR/lang8\
       --workers $WORKER_NUM \
       --srcdict ./bart1.txt  \
       --tgtdict ./bart1.txt \

echo "Finished!"
