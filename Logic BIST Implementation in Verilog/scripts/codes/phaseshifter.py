import numpy as np

def create_lfsr_matrix():
    T = np.zeros((36, 36), dtype=int)
    feedback_positions = [0, 5, 12]
    for pos in feedback_positions:
        T[pos, 35] = 1
    for i in range(1, 36):
        T[i, i - 1] = 1
    return T

def xor_matrix_multiply(B, T):
    result = np.zeros(B.shape, dtype=int)
    for i in range(B.shape[0]):
        for j in range(T.shape[1]):
            xor_sum = 0
            for k in range(T.shape[0]):
                xor_sum ^= (B[i, k] & T[k, j])
            result[i, j] = xor_sum
    return result

def create_identity_matrix():
    return np.eye(36, dtype=int)

def matrix_exponentiation(T, n):
    result = create_identity_matrix()
    if n >= 1:
        result = T
    while n > 1:
        result = xor_matrix_multiply(result, result)
        n //= 2
    return result

T = create_lfsr_matrix()
np.set_printoptions(threshold=np.inf)
print("Matrix T is:")
print(T)

n = int(input("Enter the power n (must be a power of 2): "))
B = np.zeros((1, 36), dtype=int)
position_of_one = int(input("Enter the position of 1 (0-35): "))
B[0, position_of_one] = 1

T_power_n = matrix_exponentiation(T, n)
result = xor_matrix_multiply(B, T_power_n)

print("The result of BT^n is:")
print(result)

positions_of_ones = np.where(result[0] == 1)[0]
print("Positions with value 1 are:", positions_of_ones)

