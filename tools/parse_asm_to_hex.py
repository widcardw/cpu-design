#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys, getopt, re

op_dict = {
    'add':      r"6'b0",
    'sub':      r"6'b0",
    'subu':     r"6'b0",
    'slt':      r"6'b0",
    'sltu':     r"6'b0",
    'ori':      r"6'b001101",
    'addiu':    r"6'b001001",
    'lw':       r"6'b100011",
    'sw':       r"6'b101011",
    'beq':      r"6'b000100",
    'j':        r"6'b000010"
}
func_dict = {
    'add':      r"6'b100000",
    'sub':      r"6'b100010",
    'subu':     r"6'b100011",
    'slt':      r"6'b101010",
    'sltu':     r"6'b101011",
}

type_dict = {
    'add':   "r",
    'sub':   "r",
    'subu':  "r",
    'slt':   "r",
    'sltu':  "r",
    'ori':   "i",
    'addiu': "i",
    'lw':    "i",
    'sw':    "i",
    'beq':   "i",
    'j':     "j"
}

OFFSET = 0

base_dict = {
    'b': 2,
    'h': 16
}

def get_hexcode_from_concatenate_string(s: str):
    string_list = re.split(r",\s*", s)
    context = []
    for i in range(len(string_list)):
        context.append(matchcode(string_list[i]))
    # print(context)
    result = 0
    for i in range(len(context)):
        result <<= context[i][0]
        result += int(context[i][2], base_dict[context[i][1]])
    return hex(result)
        
def formated_hex(s: str):
    code_str = get_hexcode_from_concatenate_string(s)
    code_str = code_str[2:]
    if len(code_str) < 8:
        code_str = '0' * (8 - len(code_str)) + code_str
    return code_str

def matchcode(s: str):
    pattern = r"{?(\d+)'([bh])([0-9a-fA-F]+)}?;?\n?"
    matchObj = re.match(pattern, s)
    code_length = int(matchObj.group(1))
    code_format = matchObj.group(2)
    code_context = matchObj.group(3)
    return code_length, code_format, code_context

def get_from_file(file_path: str):
    with open(file_path, 'r') as fin, open('out', 'w') as fout:
        s = fin.readlines()
        for code in s:
            print(code[:-1])
            code_str = get_hexcode_from_concatenate_string(code)
            code_str = code_str[2:]
            if len(code_str) < 8:
                code_str = '0' * (8 - len(code_str)) + code_str
            fout.write(code_str + '\n')

# get hex code
def get_rtype_code(s: str) -> str:
    pattern = r"(\w+)\s+r([0-9A-Fa-f]+)\s*,\s*r([0-9A-Fa-f]+)\s*,\s*r([0-9A-Fa-f]+)\s*"
    matchObj = re.match(pattern, s)
    op = matchObj.group(1)
    rd = int(matchObj.group(2), 16) + OFFSET
    rs = int(matchObj.group(3), 16) + OFFSET
    rt = int(matchObj.group(4), 16) + OFFSET
    code = f"{op_dict[op]}, 5'b{bin(rs)[2:]}, 5'b{bin(rt)[2:]}, 5'b{bin(rd)[2:]}, 5'b0, {func_dict[op]}"
    return code

def get_itype_code(s: str) -> str:
    pattern = r"(\w+)\s+r([0-9A-Fa-f]+)\s*,\s*r([0-9A-Fa-f]+)\s*,\s([0-9A-Fa-f]+)\s*"
    matchObj = re.match(pattern, s)
    op = matchObj.group(1)
    rt = int(matchObj.group(2), 16) + OFFSET
    rs = int(matchObj.group(3), 16) + OFFSET
    im = matchObj.group(4)
    code = f"{op_dict[op]}, 5'b{bin(rs)[2:]}, 5'b{bin(rt)[2:]}, 16'h{im}"
    return code

def get_jtype_code(s: str) -> str: 
    pattern = r"(\w+)\s+([0-9A-Fa-f]+)"
    matchObj = re.match(pattern, s)
    op = matchObj.group(1)
    target = matchObj.group(2)
    code = f"{op_dict[op]}, 26'h{target}"
    return code

def judge_code_type(s: str) -> str:
    pattern = "(\w+).*"
    matchObj = re.match(pattern, s)
    ins = matchObj.group(1)
    return type_dict[ins]

get_code_dict = {
    'r': get_rtype_code,
    'i': get_itype_code,
    'j' :get_jtype_code
}

def translate_from_asm_file(file_path: str):
    instruction_list = []
    with open(file_path, 'r') as fin:
        s = fin.readlines()
        for code in s:
            code_type = judge_code_type(code)
            instruction = get_code_dict[code_type](code)
            instruction_list.append(instruction)
    return instruction_list

# final process
def file2hex(input_file: str, output_file: str):
    instruction_list = translate_from_asm_file(input_file)
    code_list = []
    for ins in instruction_list:
        code = formated_hex(ins) + '\n'
        code_list.append(code)
    with open(output_file, 'w') as fout:
        fout.writelines(code_list)

def get_args(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print('test.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
    return inputfile, outputfile

if __name__ == "__main__":
    inputfile, outputfile = get_args(sys.argv[1:])
    print("input:", inputfile, "\toutput:", outputfile)
    file2hex(inputfile, outputfile)
    print("Successfully processed!")