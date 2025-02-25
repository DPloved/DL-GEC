CUDA_DEVICE=2
BEAM=12
N_BEST=1
SEED=2022
FAIRSEQ_DIR=../../src/src_dlgec/fairseq-0.10.2/fairseq_cli
STAGE=pinyin
TEST_DIR=../../preprocess/chinese_pinyin/bin
MODEL_DIR=../../model/chinese_bart_baseline/$SEED/$STAGE/

ID_FILE=$TEST_DIR/nlpcc.id

PROCESSED_DIR=../../preprocess/chinese_pinyin
OUTPUT_DIR=$MODEL_DIR/results

mkdir -p $OUTPUT_DIR
cp $ID_FILE $OUTPUT_DIR/test.id
cp ./test/test.src.char   $OUTPUT_DIR/test.src.char
 
echo "Generating NLPCC Test..."
SECONDS=0

CUDA_VISIBLE_DEVICES=7 python -u ${FAIRSEQ_DIR}/interactive_pinyin.py ../../preprocess/chinese_pinyin/lang_pin_2/   \
    --user-dir ../../src/src_dlgec/dlgec_model \
    --task syntax-enhanced-translation \
    --path ${MODEL_DIR}/checkpointbest.pt \
    --beam ${BEAM} \
    --nbest ${N_BEST} \
    -s src \
    -t tgt \
    --buffer-size 30000 \
    --batch-size 64 \
    --num-workers 32 \
    --log-format tqdm \
    --remove-bpe \
    --fp16 \
    --output_file $OUTPUT_DIR/test.out.nbest \
    --pinyin total.pinyin \
    < $OUTPUT_DIR/test.src.char

echo "Generating Finish!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

cat $OUTPUT_DIR/test.out.nbest | grep "^D-"  | python -c "import sys; x = sys.stdin.readlines(); x = ''.join([ x[i] for i in range(len(x)) if (i % ${N_BEST} == 0) ]); print(x)" | cut -f 3 > $OUTPUT_DIR/test.out
sed -i '$d' $OUTPUT_DIR/test.out

python ../../utils/post_process_chinese.py $OUTPUT_DIR/test.src.char $OUTPUT_DIR/test.out   $OUTPUT_DIR/clang8.output 
