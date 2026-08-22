import torch
from SpkEncoderLayer import SpkEncoderLayer
from SpkHiddenLayer import SpkHiddenLayer
from SpkOutputLayer import SpkOutputLayer
import torch.nn as nn

BATCH_SIZE = 500
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
TAU_CURR = 1e-3 # time constant for current decay

class DenseSNN(nn.Module):
  def __init__(self, n_ts):
    """
    Instantiates the DenseSNN class comprising of Spiking Encoder and Hidden 
    layers.
    
    Args:
      n_ts <int>: Number of simualtion time-steps.
    """
    super().__init__()
    self.n_ts = n_ts
    self.enc_lyr = SpkEncoderLayer(n_neurons=784) # Image to Spike Encoder layer.
    self.hdn_lyrs = torch.nn.ModuleList()
    self.hdn_lyrs.append(SpkHiddenLayer(n_prev=784, n_hidn=1024)) # 1st Hidden Layer.
    self.hdn_lyrs.append(SpkHiddenLayer(n_prev=1024, n_hidn=512)) # 2nd Hidden Layer.
    self.otp_lyr = SpkOutputLayer(n_prev=512, n_otp=10)

  def _forward_through_time(self, x):
    """
    Implements the forward function through all the simulation time-steps.
    
    Args: 
      x <Tensor>: Batch input of shape: (batch_size, 784). Note: 28x28 = 784.
    """
    all_ts_out_spks = torch.zeros(BATCH_SIZE, self.n_ts, 10) # #Classes = 10.
    # print(x.shape)
    for t in range(self.n_ts):
      spikes = self.enc_lyr.encode(x)
      for hdn_lyr in self.hdn_lyrs:
        spikes = hdn_lyr(spikes)
      spikes = self.otp_lyr(spikes)
      all_ts_out_spks[:, t] = spikes

    return all_ts_out_spks

  def forward(self, x):
    """
    Implements the forward function. 

    Args:
      x <Tensor>: Batch input of shape: (batch_size, 784). Note: 28x28 = 784.
    """
    # Re-initialize the neuron states.
    self.enc_lyr.re_initialize_voltage()
    for hdn_lyr in self.hdn_lyrs:
      hdn_lyr.re_initialize_neuron_states()
    self.otp_lyr.re_initialize_neuron_states()
    
    # Do the forward pass through time, i.e., for all the simulation time-steps.
    all_ts_out_spks = self._forward_through_time(x)
    return all_ts_out_spks