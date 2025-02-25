####################
# Train DLGEC
####################

SEED=2022
FAIRSEQ_CLI_PATH=../../src/src_dlgec/fairseq-0.10.2/fairseq_cli
MODEL_DIR_STAGE1=../../model/chinese_bart_baseline/$SEED/lang8_1
#MODEL_DIR_STAGE2=../../model/chinese_bart_baseline/$SEED/stage5
PROCESSED_DIR_STAGE1=../../preprocess/chinese_pinyin
FAIRSEQ_PATH=../../src/src_dlgec/fairseq-0.10.2/fairseq
PLMs=/home/models/BART
mkdir -p $MODEL_DIR_STAGE1

mkdir -p $MODEL_DIR_STAGE1/src

cp -r $FAIRSEQ_PATH $MODEL_DIR_STAGE1/src

cp -r $FAIRSEQ_CLI_PATH $MODEL_DIR_STAGE1/src

cp -r ../../src/src_dlgec/dlgec_model $MODEL_DIR_STAGE1/src

cp ./train_dlgec_bart.sh $MODEL_DIR_STAGE1

 
CUDA_VISIBLE_DEVICES=2,3  python -u $FAIRSEQ_CLI_PATH/train.py ../../preprocess/chinese_pinyin/lang8_2 \
    --save-dir $MODEL_DIR_STAGE1 \
    --user-dir ../../src/src_dlgec/dlgec_model \
    --task dltax-enhanced-translation \
    --arch dltax_enhanced_bart_large \
    --skip-invalid-size-inputs-valid-test \
    --max-tokens  8192 \
    --optimizer adam \
    --bart-model-file-from-transformers $PLMs  \
    --max-source-positions 512 \
    --max-target-positions 512 \
    --lr 3e-05 \
    --warmup-updates 2000 \
    -s src \
    -t tgt \
    --clip-norm 1.0 \
    --lr-scheduler polynomial_decay \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --max-epoch 2 \
    --share-all-embeddings \
    --adam-betas '(0.9,0.999)' \
    --log-format tqdm \
    --find-unused-parameters \
    --keep-last-epochs 10 \
    --patience 0 \
    --seed $SEED \
    --fp16  \


wait

