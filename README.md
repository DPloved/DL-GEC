# DLGEC
Improving Grammatical Error Correction with Dynamic Linguistic Knowledge Fusion


# Overview

we propose a novel dynamic linguistic knowledge fused language model for grammatical error correction. In this work, we regard Chinese-specific pronunciation representation ``pinyin'' and detection information as extra-linguistic knowledge to improve the correction accuracy in both traditional Sequence-to-Sequence (Seq2Seq) model and large language models.



# How to Install

You can use the following commands to install the environment for DLGEC:

```
conda create -n dlgec python==3.8
conda activate dlgec
pip install -r requirements.txt
cd src/src_dlgec/fairseq-0.10.2
pip install --editable ./
```

The DLGEC model for GEC is based on [fairseq-0.10.2](https://github.com/facebookresearch/fairseq/tree/v0.10.2).



# How to Download Pre-trained Models

BART Model:

| Name       | Download Link | Description |
|------------|---------------|-------------|
| **Bart-Base-Chinese** | [Link](https://huggingface.co/fnlp/bart-base-chinese) | Seq2Seq-based Pre-Trained Model|



# How to Train
If you want to train new models using your own dataset, please follow the instructions in `./bash/chinese_exp`:


+ `preprocess_baseline.sh`: preprocess data for training GEC models;

+ `train_pinyin_bart.sh`: train baseline & DLGEC models;

+ `generate_pinyin.sh`: generate results ;


You can use the following commands to train:

```
sh train_pinyin_bart.sh
```


# Use Your Own Data
Each data folder should contain the following files:

+ src.txt
+ tgt.txt (except test-sets)

Each line of these files should contain a sample (a line of source/target sentence).

