import torch
import numpy as np
from DenseSNN import DenseSNN

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
BATCH_SIZE = 500
MODEL_PATH = './best_model.pth'

def extract_weights():
    model = DenseSNN(n_ts=25).to(DEVICE)
    model.load_state_dict(torch.load(MODEL_PATH, map_location=DEVICE))
    all_weights = {}
    for name, params in model.named_parameters():
        np.savetxt(f'weights_{name}.txt', params.detach().cpu().numpy(), fmt='%f')

extract_weights()