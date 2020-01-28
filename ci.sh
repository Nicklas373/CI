#!bin/bash
#
# Copyright 2019, Najahiiii <najahiii@outlook.co.id>
# Copyright 2019, alanndz <alanmahmud0@gmail.com>
# Copyright 2020, Dicky Herlambang "Nicklas373" <herlambangdicky5@gmail.com>
# Copyright 2016-2020, HANA-CI Build Project
#
# Clarity Kernel Builder Script || For Continous Integration
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

# Let's make some option here
#
# Kernel Name Release
# 0 = CAF || 1 = Clarity / Fusion
#
# Kernel Type
# 0 = HMP || 1 = EAS || 2 = EAS-UC
#
# Kernel Branch Relase
# 0 = BETA || 1 = Stable
#
# Kernel Android Version
# 0 = Pie || 1 = 10 || 2 = 9 - 10
#
# Kernel Codename
# 0 = Mido || 1 = Lavender
#
# Kernel Extend Defconfig
# 0 = Dev-Mido || 1 = Dev-Lave || 2 = Null
#
# Kernel Compiler
# 0 = Clang 10.0.0 (Pendulum Clang)
# 1 = Clang 10.0.0 (LiuNian Clang 10.0.0)
# 2 = Clang 10.0.0 (Proton Clang 10.0.0)
# 3 = Clang 10.0.3 + (GCC 4.9 Non-elf 32/64)
# 4 = Clang 11.0.0 (Nusantara Clang)
# 5 = Clang 11.0.0 (Proton Clang prebuilt 202001017)
# 6 = Clang 11.0.0 (LiuNian clang 2020/01/18-2)
#
# CI Init
# 0 = Circle-CI || 1 = Drone-CI
#
KERNEL_NAME_RELEASE="1"
KERNEL_TYPE="1"
KERNEL_BRANCH_RELEASE="0"
KERNEL_ANDROID_VERSION="1"
KERNEL_CODENAME="1"
KERNEL_EXTEND="2"
KERNEL_COMPILER="2"
KERNEL_CI="1"

# Compiling For Mido // If mido was selected
if [ "$KERNEL_CODENAME" == "0" ];
	then
		# Create Temporary Folder
		mkdir TEMP

		if [ "$KERNEL_NAME_RELEASE" == "0" ];
			then
				# Clone kernel & other repositories earlier
				git clone --depth=1 -b pie https://github.com/Nicklas373/kernel_xiaomi_msm8953-3.18-2 kernel
				git clone --depth=1 -b caf/mido https://github.com/Nicklas373/AnyKernel3

				# Define Kernel Scheduler
				KERNEL_SCHED="HMP"
				KERNEL_BRANCH="pie"

		elif [ "$KERNEL_NAME_RELEASE" == "1" ];
			then
				if [ "$KERNEL_TYPE" == "1" ];
					then
						# Clone kernel & other repositories earlier
						git clone --depth=1 -b dev/kasumi https://github.com/Nicklas373/kernel_xiaomi_msm8953-3.18-2 kernel

						# Define Kernel Scheduler
						KERNEL_SCHED="EAS"
						KERNEL_BRANCH="dev/kasumi"
				elif [ "$KERNEL_TYPE" == "2" ];
					then
						# Clone kernel & other repositories earlier
						git clone --depth=1 -b dev/kasumi-uc https://github.com/Nicklas373/kernel_xiaomi_msm8953-3.18-2 kernel

						# Define Kernel Scheduler
						KERNEL_SCHED="EAS-UC"
						KERNEL_BRANCH="dev/kasumi-uc"
				fi

				# Detect Android Version earlier and clone AnyKernel depend on android version
				if [ "$KERNEL_ANDROID_VERSION" == "0" ];
					then
						git clone --depth=1 -b mido https://github.com/Nicklas373/AnyKernel3
				else
						git clone --depth=1 -b mido-10 https://github.com/Nicklas373/AnyKernel3
				fi
		fi
# Compiling Repository For Lavender // If lavender was selected
elif [ "$KERNEL_CODENAME" == "1" ];
	then

		# Cloning Kernel Repository // If compiled by Drone CI
		if [ "$KERNEL_CI" == "1" ];
			then
				git clone --depth=1 -b hmp-debug https://Nicklas373:$token@github.com/Nicklas373/kernel_xiaomi_lavender-4.4 kernel
		fi

		# Cloning AnyKernel Repository
		git clone --depth=1 -b lavender https://github.com/Nicklas373/AnyKernel3

		# Create Temporary Folder
		mkdir TEMP

		# Define Kernel Scheduler
		KERNEL_SCHED="HMP"
		KERNEL_BRANCH="hmp-debug"
fi
if [ "$KERNEL_COMPILER" == "0" ];
	then
		# Cloning Toolchains Repository
		git clone --depth=1 https://github.com/Haseo97/Clang-10.0.0 -b clang-10.0.0 clang-2
elif [ "$KERNEL_COMPILER" == "1" ];
	then
		# Cloning Toolchains Repository
		git clone --depth=1 https://github.com/HANA-CI-Build-Project/LiuNian-clang -b clang-10 l-clang
elif [ "$KERNEL_COMPILER" == "2" ];
	then
		# Cloning Toolchains Repository
		git clone --depth=1 https://github.com/HANA-CI-Build-Project/proton-clang -b master p-clang
elif [ "$KERNEL_COMPILER" == "3" ];
	then
		# Cloning Toolchains Repository
		echo "Use latest AOSP Clang & GCC 4.9 From Najahii Oven"
elif [ "$KERNEL_COMPILER" == "4" ];
	then
		# Cloning Toolchains Repository
		echo "Use latest nusantara clang"
elif [ "$KERNEL_COMPILER" == "5" ];
        then
                # Cloning Toolchains Repository
                git clone --depth=1 https://github.com/HANA-CI-Build-Project/proton-clang -b proton-clang-11 p-clang
elif [ "$KERNEL_COMPILER" == "6" ];
	then
		# Cloning Toolchains Repository
		git clone --depth=1 https://github.com/HANA-CI-Build-Project/LiuNian-clang -b master l-clang
fi

# Kernel Enviroment
export ARCH=arm64
if [ "$KERNEL_CI" == "0" ];
	then
		KERNEL_BOT="Circle-CI"
elif [ "$KERNEL_CI" == "1" ];
	then
		KERNEL_BOT="Drone-CI"
fi
if [ "$KERNEL_COMPILER" == "0" ];
	then
		export CLANG_PATH=$(pwd)/clang-2/bin
		export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="$(pwd)/clang-2/bin/../lib:$PATH"
elif [ "$KERNEL_COMPILER" == "1" ] || [ "$KERNEL_COMPILER" == "6" ];
	then
		export CLANG_PATH=$(pwd)/l-clang/bin
                export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="$(pwd)/l-clang-2/bin/../lib:$PATH"
elif [ "$KERNEL_COMPILER" == "2" ] || [ "$KERNEL_COMPILER" == "5" ];
	then
		export CLANG_PATH=$(pwd)/p-clang/bin
                export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="$(pwd)/p-clang/bin/../lib:$PATH"
elif [ "$KERNEL_COMPILER" == "3" ]
	then
		export CLANG_PATH=/root/aosp-clang/bin
		export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="/root/aosp-clang/bin/../lib:$PATH"
		export CROSS_COMPILE=/root/gcc-4.9/arm64/bin/aarch64-linux-android-
		export CROSS_COMPILE_ARM32=/root/gcc-4.9/arm/bin/arm-linux-androideabi-
elif [ "$KERNEL_COMPILER" == "4" ]
	then
		export LD_LIBRARY_PATH="root/clang/bin/../lib:$PATH"
fi
export KBUILD_BUILD_USER=Kasumi
export KBUILD_BUILD_HOST=${KERNEL_BOT}
# Kernel aliases
if [ "$KERNEL_CODENAME" == "0" ];
	then
		IMAGE="$(pwd)/kernel/out/arch/arm64/boot/Image.gz-dtb"
		KERNEL="$(pwd)/kernel"
		KERNEL_TEMP="$(pwd)/TEMP"
		CODENAME="mido"
		KERNEL_CODE="Mido"
		TELEGRAM_DEVICE="Xiaomi Redmi Note 4x"
elif [ "$KERNEL_CODENAME" == "1" ];
	then
		IMAGE="$(pwd)/out/arch/arm64/boot/Image.gz-dtb"
		KERNEL="$(pwd)"
		KERNEL_TEMP="$(pwd)/TEMP"
		CODENAME="lavender"
		KERNEL_CODE="Lavender"
		TELEGRAM_DEVICE="Xiaomi Redmi Note 7"
fi
if [ "$KERNEL_TYPE" == "0" ];
	then
		# Kernel extend aliases
		KERNEL_REV="r11"
		KERNEL_NAME="CAF"
elif [ "$KERNEL_TYPE" == "1" ];
	then
		if [ "$KERNEL_CODENAME" == "0" ];
			then
				# Kernel extend aliases
				KERNEL_REV="r17"
				KERNEL_NAME="Clarity"
		elif [ "$KERNEL_CODENAME" == "1" ];
			then
				 # Kernel extend aliases
				KERNEL_REV="r1"
				KERNEL_NAME="Fusion"
		fi
elif [ "$KERNEL_TYPE" == "2" ];
	then
		# Kernel extend aliases
		KERNEL_REV="r17"
		KERNEL_NAME="Clarity"
fi
KERNEL_SUFFIX="Kernel"
KERNEL_DATE="$(date +%Y%m%d-%H%M)"
if [ "$KERNEL_ANDROID_VERSION" == "0" ];
	then
		KERNEL_ANDROID_VER="9"
		KERNEL_TAG="P"
elif [ "$KERNEL_ANDROID_VERSION" == "1" ];
	then
		KERNEL_ANDROID_VER="10"
		KERNEL_TAG="Q"
elif [ "$KERNEL_ANDROID_VERSION" == "2" ];
	then
		KERNEL_ANDROID_VER="9-10"
		KERNEL_TAG="P-Q"
fi
if [ "$KERNEL_BRANCH_RELEASE" == "1" ];
	then
		KERNEL_RELEASE="Stable"
elif [ "$KERNEL_BRANCH_RELEASE" == "0" ];
	then
		KERNEL_RELEASE="BETA"
fi

# Telegram aliases
if [ "$KERNEL_CI" == "0" ];
	then
		TELEGRAM_BOT_ID=${telegram_bot_id}
		if [ "$KERNEL_BRANCH_RELEASE" == "1" ];
			then
				TELEGRAM_GROUP_ID=${telegram_group_official_id}
		elif [ "$KERNEL_BRANCH_RELEASE" == "0" ];
			then
				TELEGRAM_GROUP_ID=${telegram_group_dev_id}
		fi
elif [ "$KERNEL_CI" == "1" ];
	then
		TELEGRAM_BOT_ID=${tg_bot_id}
                if [ "$KERNEL_BRANCH_RELEASE" == "1" ];
			then
				TELEGRAM_GROUP_ID=${tg_channel_id}
                elif [ "$KERNEL_BRANCH_RELEASE" == "0" ];
                        then
                                TELEGRAM_GROUP_ID=${tg_group_id}
                fi
fi
TELEGRAM_FILENAME="${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip"
export TELEGRAM_SUCCESS="CAADAgADDSMAAuCjggeXsvhpxp-R4xYE"
export TELEGRAM_FAIL="CAADAgADAiMAAuCjggeCh9mRFWEJ9RYE"

# Import telegram bot environment
function bot_env() {
TELEGRAM_KERNEL_VER=$(cat ${KERNEL}/out/.config | grep Linux/arm64 | cut -d " " -f3)
TELEGRAM_UTS_VER=$(cat ${KERNEL}/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
TELEGRAM_COMPILER_NAME=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILE_BY | cut -d '"' -f2)
TELEGRAM_COMPILER_HOST=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILE_HOST | cut -d '"' -f2)
TELEGRAM_TOOLCHAIN_VER=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
}

# Telegram Bot Service || Compiling Notification
function bot_template() {
curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendMessage -d chat_id=${TELEGRAM_GROUP_ID} -d "parse_mode=HTML" -d text="$(
            for POST in "${@}"; do
                echo "${POST}"
            done
          )"
}

# Telegram bot message || first notification
function bot_first_compile() {
bot_template  "<b>|| ${KERNEL_BOT} Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Start!</b>" \
	      "" \
 	      "<b>Build Status :</b><code> ${KERNEL_RELEASE} </code>" \
              "<b>Device :</b><code> ${TELEGRAM_DEVICE} </code>" \
	      "<b>Android Version :</b><code> ${KERNEL_ANDROID_VER} </code>" \
	      "" \
	      "<b>Kernel Scheduler :</b><code> ${KERNEL_SCHED} </code>" \
	      "<b>Kernel Branch :</b><code> ${KERNEL_BRANCH} </code>" \
              "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1) </code>"
}

# Telegram bot message || complete compile notification
function bot_complete_compile() {
bot_env
bot_template  "<b>|| ${KERNEL_BOT} Build Bot ||</b>" \
    "" \
    "<b>New ${KERNEL_NAME} Kernel Build Is Available!</b>" \
    "" \
    "<b>Build Status :</b><code> ${KERNEL_RELEASE} </code>" \
    "<b>Device :</b><code> ${TELEGRAM_DEVICE} </code>" \
    "<b>Android Version :</b><code> ${KERNEL_ANDROID_VER} </code>" \
    "<b>Filename :</b><code> ${TELEGRAM_FILENAME}</code>" \
     "" \
    "<b>Kernel Scheduler :</b><code> ${KERNEL_SCHED} </code>" \
    "<b>Kernel Version:</b><code> Linux ${TELEGRAM_KERNEL_VER}</code>" \
    "<b>Kernel Host:</b><code> ${TELEGRAM_COMPILER_NAME}@${TELEGRAM_COMPILER_HOST}</code>" \
    "<b>Kernel Toolchain :</b><code> ${TELEGRAM_TOOLCHAIN_VER}</code>" \
    "<b>UTS Version :</b><code> ${TELEGRAM_UTS_VER}</code>" \
    "" \
    "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1)</code>" \
    "<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>" \
    "" \
    "<b>                         HANA-CI Build Project | 2016-2020                            </b>"
}

# Telegram bot message || success notification
function bot_build_success() {
bot_template  "<b>|| ${KERNEL_BOT} Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Success!</b>"
}

# Telegram bot message || failed notification
function bot_build_failed() {
bot_template "<b>|| ${KERNEL_BOT} Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Failed!</b>" \
              "" \
              "<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>"
}

# Telegram sticker message
function sendStick() {
	curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_ID/sendSticker -d sticker="${1}" -d chat_id=$TELEGRAM_GROUP_ID &>/dev/null
}

# Compile Begin
function compile() {
	if [ "$KERNEL_CODENAME" == "0" ];
		then
			cd ${KERNEL}
			bot_first_compile
			cd ..
			if [ "$KERNEL_EXTEND" == "0" ];
				then
					if [ "$KERNEL_TYPE" == "1" ] ;
						then
							sed -i -e 's/-友希那-Kernel-r17-LA.UM.8.6.r1-02900-89xx.0/-戸山-Kernel-r17-LA.UM.8.6.r1-02900-89xx.0/g'  ${KERNEL}/arch/arm64/configs/mido_defconfig
					elif [ "$KERNEL_TYPE" == "2" ];
						then
							sed -i -e 's/-友希那-Kernel-r17-UC-LA.UM.8.6.r1-02900-89xx.0/-戸山-Kernel-r17-UC-LA.UM.8.6.r1-02900-89xx.0/g' ${KERNEL}/arch/arm64/configs/mido_defconfig
					fi
			fi
			START=$(date +"%s")
			make -s -C ${KERNEL} ${CODENAME}_defconfig O=out
		if [ "$KERNEL_COMPILER" == "0" ];
			then
				PATH="$(pwd)/clang-2/bin/:${PATH}" \
        			make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
								CLANG_TRIPLE=aarch64-linux-gnu- \
		        					CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		elif [ "$KERNEL_COMPILER" == "1" ] || [ "$KERNEL_COMPILER" == "6" ];
			then
				PATH="$(pwd)/l-clang/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
                                                                CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		elif [ "$KERNEL_COMPILER" == "2" ] || [ "$KERNEL_COMPILER" == "5" ];
			then
				PATH="$(pwd)/p-clang/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
								CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		elif [ "$KERNEL_COMPILER" == "3" ]
			then
				PATH="/root/aosp-clang/bin/:/root/gcc-4.9/arm64/bin/:/root/gcc-4.9/arm/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
                                                                CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=${CROSS_COMPILE} \
								CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32}
		elif [ "$KERNEL_COMPILER" == "4" ]
			then
				PATH="/root/clang/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
								CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		fi
		if ! [ -a $IMAGE ];
			then
                		echo "kernel not found"
                		END=$(date +"%s")
                		DIFF=$(($END - $START))
				cd ${KERNEL}
                		bot_build_failed
				cd ..
				sendStick "${TELEGRAM_FAIL}"
				curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/compile.log"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
                		exit 1
        	fi
        	END=$(date +"%s")
        	DIFF=$(($END - $START))
		cd ${KERNEL}
		bot_build_success
		cd ..
		sendStick "${TELEGRAM_SUCCESS}"
		cp ${IMAGE} AnyKernel3
		anykernel
		kernel_upload
	elif [ "$KERNEL_CODENAME" == "1" ];
		then
			cd ${KERNEL}
			bot_first_compile
			cd ..
			START=$(date +"%s")
			make -s -C ${KERNEL} ${CODENAME}_defconfig O=out
			if [ "$KERNEL_COMPILER" == "0" ];
				then
					PATH="$(pwd)/clang-2/bin/:${PATH}" \
					make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
										CC=clang \
										CLANG_TRIPLE=aarch64-linux-gnu- \
										CROSS_COMPILE=aarch64-linux-gnu- \
										CROSS_COMPILE_ARM32=arm-linux-gnueabi-
			elif [ "$KERNEL_COMPILER" == "1" ] || [ "$KERNEL_COMPILER" == "6" ];
     				then
					PATH="$(pwd)/l-clang/bin/:${PATH}" \
					make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
										CC=clang \
										CLANG_TRIPLE=aarch64-linux-gnu- \
										CROSS_COMPILE=aarch64-linux-gnu- \
										CROSS_COMPILE_ARM32=arm-linux-gnueabi-
			elif [ "$KERNEL_COMPILER" == "2" ] || [ "$KERNEL_COMPILER" == "5" ];
				then
					PATH="$(pwd)/p-clang/bin/:${PATH}" \
					make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
										CC=clang \
										CLANG_TRIPLE=aarch64-linux-gnu- \
										CROSS_COMPILE=aarch64-linux-gnu- \
										CROSS_COMPILE_ARM32=arm-linux-gnueabi-
			elif [ "$KERNEL_COMPILER" == "3" ]
				then
					PATH="/root/aosp-clang/bin/:/root/gcc-4.9/arm64/bin/:/root/gcc-4.9/arm/bin/:${PATH}" \
					make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
										CC=clang \
										CLANG_TRIPLE=aarch64-linux-gnu- \
										CROSS_COMPILE=${CROSS_COMPILE} \
										CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32}
			elif [ "$KERNEL_COMPILER" == "4" ]
				then
					PATH="/root/clang/bin/:${PATH}" \
					make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
										CC=clang \
										CLANG_TRIPLE=aarch64-linux-gnu- \
										CROSS_COMPILE=aarch64-linux-gnu- \
										CROSS_COMPILE_ARM32=arm-linux-gnueabi-
			fi
			if ! [ -a $IMAGE ];
				then
                			echo "kernel not found"
                			END=$(date +"%s")
                			DIFF=$(($END - $START))
                			bot_build_failed
					sendStick "${TELEGRAM_FAIL}"
					curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/compile.log"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
               				exit 1
        		fi
       			END=$(date +"%s")
        		DIFF=$(($END - $START))
			bot_build_success
			sendStick "${TELEGRAM_SUCCESS}"
			if [ "$KERNEL_CI" == "0" ];
				then
					cd ${KERNEL}
			elif [ "$KERNEL_CI" == "1" ];
				then
					echo ""
			fi
        		cp ${IMAGE} AnyKernel3
			anykernel
			kernel_upload
	fi
}

# AnyKernel
function anykernel() {
	cd AnyKernel3
	make -j4
        mv Clarity-Kernel-${KERNEL_CODE}-signed.zip  ${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip
}

# Upload Kernel
function kernel_upload(){
	cd ${KERNEL}
	bot_complete_compile
	if [ "$KERNEL_CODENAME" == "0" ];
		then
			cd ${KERNEL_TEMP}
	fi
	curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
	if [ "$KERNEL_BRANCH_RELEASE" == "0" ];
		then
			curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/compile.log"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
	fi
}

# Running
compile
