# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	FG_BLACK   := $(shell tput -Txterm setaf 0)
	FG_RED     := $(shell tput -Txterm setaf 1)
	FG_GREEN   := $(shell tput -Txterm setaf 2)
	FG_YELLOW  := $(shell tput -Txterm setaf 3)
	FG_LPURPLE := $(shell tput -Txterm setaf 4)
	FG_PURPLE  := $(shell tput -Txterm setaf 5)
	FG_BLUE    := $(shell tput -Txterm setaf 6)
	FG_WHITE   := $(shell tput -Txterm setaf 7)
	FG_RESET   := $(shell tput -Txterm sgr0)
else
	FG_BLACK   := ""
	FG_RED     := ""
	FG_GREEN   := ""
	FG_YELLOW  := ""
	FG_LPURPLE := ""
	FG_PURPLE  := ""
	FG_BLUE    := ""
	FG_WHITE   := ""
	FG_RESET   := ""
endif
