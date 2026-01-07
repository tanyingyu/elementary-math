MAIN=elementary-math-note

OUT_DIR := out

IMAGES_PATH := images

# 定义要使用的引擎
LATEXMK_ENGINE = xelatex

SRC_DIR := .

TEX_SUBDIRS := $(shell find $(SRC_DIR) -maxdepth 2 -not -path '*/.*' -type d)


LATEXOPTIONS := -bibtex-cond1  -file-line-error -synctex=1 -interaction=nonstopmode
LATEXOPTIONS += -outdir=$(OUT_DIR) 

# 定义递归获取文件的函数
recursive_wildcard = $(foreach d,$(wildcard $(1:=/*)),$(call recursive_wildcard,$d,$2) $(filter $(subst *,%,$2),$d))

ASY_FILES := $(call recursive_wildcard,$(SRC_DIR),*.asy)
# 将 *.asy 映射为 *.pdf
PDF_FIGURES = $(patsubst $(SRC_DIR)/%.asy, $(IMAGES_PATH)/%.pdf, $(ASY_FILES))


.PHONY: $(MAIN).pdf all clean cleanall info

all:  $(OUT_DIR) $(PDF_FIGURES) $(MAIN).pdf

%.tex: %.raw
	./raw2tex $< > $@

%.tex: %.dat
	./dat2tex $< > $@

$(MAIN).pdf: $(MAIN).tex
	latexmk -$(LATEXMK_ENGINE) $(LATEXOPTIONS) $<

# --- 创建输出目录 ---
$(OUT_DIR):
	mkdir -p $(OUT_DIR)
	@for dir in $(TEX_SUBDIRS); do mkdir -p $(OUT_DIR)/$$dir; done


$(IMAGES_PATH)/%.pdf: $(SRC_DIR)/%.asy | $(IMAGES_PATH)
	@echo "正在编译: $<"
	@# 关键：自动创建目标文件所在的子目录（如 build/chapter1/）
	@mkdir -p $(dir $@)
	@# 运行 asy 编译：
	@# -f pdf: 指定格式
	@# -o $(basename $@): 指定输出路径（不带扩展名）
	asy -f pdf -o $(basename $@) $<

# 创建输出
$(IMAGES_PATH):
	mkdir -p $(IMAGES_PATH)

# 清理所有生成的 PDF 和中间文件
cleanimg:
	@echo "正在图片文件"
	@rm $(PDF_FIGURES)

# 调试用：查看识别到了哪些文件
info:
	@echo "找到的源码文件: $(ASY_FILES)"
	@echo "将要生成的 PDF: $(PDF_FIGURES)"


cleanall:
	latexmk -C $(LATEXOPTIONS)

clean:
	latexmk -c $(LATEXOPTIONS)

