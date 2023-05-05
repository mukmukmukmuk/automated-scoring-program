################################################

# Student ID: 20211496

################################################

src_dir="submit"
build_dir="build"
tc_dir="test_case"
log_dir="logs"
output_dir="output"
result_list="result.list"
num_of_test_case=3


################################################

# Don't modify the variables above             #
# Write your own program below the comment box #

################################################

#initinal setting
rm -rf $build_dir
rm -rf $log_dir
rm -rf $output_dir
rm -f $result_list
mkdir $log_dir
mkdir $output_dir
mkdir $build_dir
touch $result_list


while read student
do
    if [ -e ${src_dir}/${student}.* ]
    then
        #Compile
        gcc -o $student $src_dir/${student}.c > ${student}.log  2>&1

        if [ $? -ne 0 ]
        then
            #Compile error
            echo "${student} 1" >> $result_list
            mv ${student}.log ./${log_dir}
        else
            mv ${student}.log ./${log_dir}
            cnt=0
            score=2
            while [ $cnt -lt ${num_of_test_case} ]
            do 
                ((cnt++))

                #execute file & write the result to output file 
                echo $(./$student < $tc_dir/in_$cnt) > ${output_dir}/${student}_${cnt}
                #edit log file
                echo "test case $cnt" >> $log_dir/${student}.log
                
                #compare the answer
                tmp=$(diff -w "${output_dir}/${student}_${cnt}" "$tc_dir/ans_$cnt")
                if [ "$tmp" ] 
                then
                    echo -e "$tmp\nwrong answer\n" >> $log_dir/${student}.log
                else
                    echo -e "pass\n">> $log_dir/${student}.log
                    score=$(($score+2))
                fi
            done
            
            #grading
            echo "$student $score" >> $result_list
            mv $student ./$build_dir
        fi
    else
        #no submit error
        echo "$student 0" >> $result_list
        echo "not submitted">> $log_dir/${student}.log
    fi
done < students.list