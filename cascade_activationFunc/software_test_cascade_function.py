import numpy as np
import math


def RELU(x):
    z = x if x > 0 else 0
    return z

def leakyRelu(x):
    if x > 0:
        z = x
    else:
        z = x/64
    return z


def hardtanh(x):
    if x > 1:
        z = 1
    else:
        if x < -1:
            z = -1
        else:
            z = x
    return z

def sigmoid(z):
    x = 1.0 / (1.0 + np.exp(-z))
    return x

def softMax_simluate_hw(input):
    max_in = input.max()

    sub1 = np.zeros(len(input))
    exp1 = np.zeros(len(input))
    sum_exp = 0
    for i in range(len(input)):
        sub1[i] = input[i] - max_in
        exp1[i] = math.exp(sub1[i])
        sum_exp += exp1[i]

    log1 = math.log(sum_exp)

    sub2 = np.zeros(len(input))
    for i in range(len(input)):
        sub2[i] = sub1[i] - log1

    softmax = np.zeros(len(input))
    for i in range(len(input)):
        softmax[i] = math.exp(sub2[i])

    sum_softmax = 0
    for i in range(len(input)):
        sum_softmax += softmax[i]

    # print variable
    for i in range(len(exp1)):
        # print(exp1[i])
        print(softmax[i])
    return softmax

input = np.zeros(4)
level1 = np.zeros(4)
softmaxout = np.zeros(4)
level3 = np.zeros(4)


input[0] = 64/2**14
input[1] = 48/2**14
input[2] = 32/2**14
input[3] = 16/2**14

level1[0] = RELU(input[0])
level1[1] = sigmoid(input[1])
level1[2] = hardtanh(input[2])
level1[3] = leakyRelu(input[3])


def softMax(input):
    exp = np.zeros(len(input))
    sum = 0
    for i in range(len(input)):
        exp[i] = math.exp(input[i])
        sum += exp[i]
    softmax = np.zeros(len(input))
    for i in range(len(input)):
        softmax[i] = exp[i]/sum
    return softmax


softmaxout = softMax(level1)
softmaxout = softMax_simluate_hw(level1)

level3[0] = sigmoid(softmaxout[0])
level3[1] = hardtanh(softmaxout[1])
level3[2] = leakyRelu(softmaxout[2])
level3[3] = RELU(softmaxout[3])
print('input:')
for i in range(len(input)):
    # print(exp1[i])
    print(input[i])
print('level1:')
for i in range(len(level1)):
    # print(exp1[i])
    print(level1[i])
print('softmax:')
for i in range(len(softmaxout)):
    # print(exp1[i])
    print(softmaxout[i])
print('level3:')
for i in range(len(level3)):
    # print(exp1[i])
    print(level3[i])
# for i in range(len(input)):
#     input[i] = i*2**(-4)

