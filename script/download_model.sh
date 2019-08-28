#
#   2 Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
#   3 Neither the names of the copyright holders nor the names of the
#   contributors may be used to endorse or promote products derived from this
#   software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#   =======================================================================
script_path="$( cd "$(dirname "$0")" ; pwd -P )"

tools_version=$1

function download()
{
    model_name=$1
    model_remote_path=$2
    rm -rf ${script_path}/${model_name}_${tools_version}.om.ing
    model_shape=`head -1 ${script_path}/shape_${model_name}`
    echo "${model_shape}"
    if [ ! -f "${script_path}/${model_name}_${tools_version}.om" ];then
        download_url_caffemodel="https://obs-model-ascend.obs.cn-east-2.myhuaweicloud.com/${model_name}/${model_name}.caffemodel"
	download_url_prototxt="https://obs-model-ascend.obs.cn-east-2.myhuaweicloud.com/${model_name}/${model_name}.prototxt"
        wget -O ${script_path}/${model_name}_${tools_version}.caffemodel ${download_url_caffemodel} --no-check-certificate
	wget -O ${script_path}/${model_name}_${tools_version}.prototxt ${download_url_prototxt} --no-check-certificate
	
	if [ ${model_name} == "vgg_ssd" -o ${model_name} == "car_plate_detection" ];then
		export SLOG_PRINT_TO_STDOUT=1 && export PATH=${PATH}:${DDK_HOME}/uihost/toolchains/ccec-linux/bin/ && export LD_LIBRARY_PATH=${DDK_HOME}/uihost/lib/ && export TVM_AICPU_LIBRARY_PATH=${DDK_HOME}/uihost/lib/:${DDK_HOME}/uihost/toolchains/ccec-linux/aicpu_lib && export TVM_AICPU_INCLUDE_PATH=${DDK_HOME}/include/inc/tensor_engine && export PYTHONPATH=${DDK_HOME}/site-packages && export TVM_AICPU_OS_SYSROOT=/usr/aarch64-linux-gnu && ${DDK_HOME}/uihost/bin/omg --output="${script_path}/${model_name}_${tools_version}" --check_report=${script_path}/${model_name}_result.json --plugin_path= --model="${script_path}/${model_name}_${tools_version}.prototxt" --framework=0 --ddk_version=${tools_version} --weight="${script_path}/${model_name}_${tools_version}.caffemodel" --input_shape=${model_shape} --insert_op_conf=${script_path}/aipp_${model_name}.cfg --op_name_map=${script_path}/reassign_operators
        else
		export SLOG_PRINT_TO_STDOUT=1 && export PATH=${PATH}:${DDK_HOME}/uihost/toolchains/ccec-linux/bin/ && export LD_LIBRARY_PATH=${DDK_HOME}/uihost/lib/ && export TVM_AICPU_LIBRARY_PATH=${DDK_HOME}/uihost/lib/:${DDK_HOME}/uihost/toolchains/ccec-linux/aicpu_lib && export TVM_AICPU_INCLUDE_PATH=${DDK_HOME}/include/inc/tensor_engine && export PYTHONPATH=${DDK_HOME}/site-packages && export TVM_AICPU_OS_SYSROOT=/usr/aarch64-linux-gnu && ${DDK_HOME}/uihost/bin/omg --output="${script_path}/${model_name}_${tools_version}" --check_report=${script_path}/${model_name}_result.json --plugin_path= --model="${script_path}/${model_name}_${tools_version}.prototxt" --framework=0 --ddk_version=${tools_version} --weight="${script_path}/${model_name}_${tools_version}.caffemodel" --input_shape=${model_shape} --insert_op_conf=${script_path}/aipp_${model_name}.cfg
	fi
	if [ $? -ne 0 ];then
            echo "ERROR: download failed, please check ${download_url} connetction."
            rm -rf ${script_path}/${model_name}_${tools_version}.caffemodel
            rm -rf ${script_path}/${model_name}_${tools_version}.prototxt
	    rm -rf ${script_path}/${model_name}_${tools_version}.om.ing
            return 1
        fi
    else
        echo "${script_path}/${model_name}_${tools_version}.om exists, skip downloading."
    fi
    
    return 0
}

main()
{
    if [[ ${tools_version}"X" == "X" ]];then
        echo "ERROR: Invalid tools version. please get tools_version from IDE help menu."
        return 1
    fi

    if [ $? -ne 0 ];then
        return 1
    fi

    download_models=`echo $* | cut -d ' ' -f 2- `
    for model_info in ${download_models}
    do
        model_remote_path=`dirname ${model_info}`
        model_name=`basename ${model_info}`

        download ${model_name} ${model_remote_path}
        if [ $? -ne 0 ];then
            return 1
        fi
    done

    echo "${model_name} finish to prepare successfully."
    return 0
}

main $*
