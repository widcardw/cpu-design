#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys
import getopt
import re

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
    'h': 16,
    'd': 10
}

reg_dict = {
    'zero': 0,
    'at': 1,
    'v0': 2,
    'v1': 3,
    **{f"a{i}": 4 + i for i in range(4)},
    **{f"t{i}": 8 + i for i in range(8)},
    **{f"s{i}": 16 + i for i in range(8)},
    't8': 24,
    't9': 25,
    'k0': 26,
    'k1': 27,
    'gp': 28,
    'sp': 29,
    'fp': 30,
    'ra': 31,
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
    pattern = r"{?(\d+)'([bhd])([0-9a-fA-F]+)}?;?\n?"
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


def get_rtype_code(s: str, line_number: int) -> str:
    # pattern = r"(\w+)\s+r([0-9A-Fa-f]+)\s*,\s*r([0-9A-Fa-f]+)\s*,\s*r([0-9A-Fa-f]+)\s*"
    pattern = r"(\w+)\s+(\w+\d*)\s*,\s*(\w+\d*)\s*,\s*(\w+\d*)\s*(\/?\/?.*?)"
    matchObj = re.match(pattern, s)
    try:
        op = matchObj.group(1)
        # rd = int(matchObj.group(2), 16) + OFFSET
        # rs = int(matchObj.group(3), 16) + OFFSET
        # rt = int(matchObj.group(4), 16) + OFFSET
        rd = matchObj.group(2)
        rs = matchObj.group(3)
        rt = matchObj.group(4)
        # code = f"{op_dict[op]}, 5'b{bin(rs)[2:]}, 5'b{bin(rt)[2:]}, 5'b{bin(rd)[2:]}, 5'b0, {func_dict[op]}"
        code = f"{op_dict[op]}, 5'b{bin(reg_dict[rs])[2:]}, 5'b{bin(reg_dict[rt])[2:]}, 5'b{bin(reg_dict[rd])[2:]}, 5'b0, {func_dict[op]}"
        return code
    except:
        print("Error at rtype code:\n", f"line {line_number}: {s}")
        print(
            "Warning:\n"
            "rtype code should be of the form:\n"
            "(OP)add\t(reg)t0, (reg)t1, (reg)t2")
        sys.exit(-1)


def get_itype_code(s: str, line_number: int) -> str:
    # pattern = r"(\w+)\s+r([0-9A-Fa-f]+)\s*,\s*r([0-9A-Fa-f]+)\s*,\s([0-9A-Fa-f]+)\s*"
    pattern = r"(\w+)\s+(\w+\d*)\s*,\s*(\w+\d*)\s*,\s*([0-9A-Fa-f]+)\s*(\/?\/?.*?)"
    matchObj = re.match(pattern, s)
    try:
        op = matchObj.group(1)
        # rt = int(matchObj.group(2), 16) + OFFSET
        # rs = int(matchObj.group(3), 16) + OFFSET
        rt = matchObj.group(2)
        rs = matchObj.group(3)
        im = matchObj.group(4)
        # code = f"{op_dict[op]}, 5'b{bin(rs)[2:]}, 5'b{bin(rt)[2:]}, 16'h{im}"
        code = f"{op_dict[op]}, 5'b{bin(reg_dict[rs])[2:]}, 5'b{bin(reg_dict[rt])[2:]}, 16'h{im}"
        return code
    except:
        print("Error at itype code:\n", f"line {line_number}: {s}")
        print(
            "Warning:\n"
            "itype code should be of the form:\n"
            "(OP)ori\t(reg)t0, (reg)t1, (imm)80")
        sys.exit(-1)


def get_jtype_code(s: str, line_number: int) -> str:
    try:
        pattern = r"(\w+)\s+([0-9A-Fa-f]+)\s*(\/?\/?.*?)"
        matchObj = re.match(pattern, s)
        op = matchObj.group(1)
        target = matchObj.group(2)
        code = f"{op_dict[op]}, 26'h{target}"
        return code
    except:
        print("Error at jtype code:\n", f"line {line_number}: {s}")
        print(
            "Warning:\n"
            "jtype code should be of the form:\n"
            "(OP)j\t(imm)8000")
        sys.exit(-1)


def judge_code_type(s: str) -> str:
    pattern = r"(\w+).*"
    matchObj = re.match(pattern, s)
    ins = matchObj.group(1)
    return type_dict[ins]


get_code_dict = {
    'r': get_rtype_code,
    'i': get_itype_code,
    'j': get_jtype_code
}


def translate_from_asm_file(file_path: str):
    instruction_list = []
    with open(file_path, 'r') as fin:
        s = fin.readlines()
        for i in range(len(s)):
            if s[i].strip() == "":
                continue
            code_type = judge_code_type(s[i])
            instruction = get_code_dict[code_type](s[i], i + 1)
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
        opts, args = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
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
    # print("input:", inputfile, "\toutput:", outputfile)
    file2hex(inputfile, outputfile)
    print("Successfully processed!")
    # with open("code2.asm", 'r') as fin:
    #     s = fin.readlines()
    #     ss = []
    #     for code in s:
    #         # ss.append(formated_hex(code) + '\n')
    #         print(formated_hex(code))
