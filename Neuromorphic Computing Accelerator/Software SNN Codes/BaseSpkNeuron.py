from abc import ABC, abstractmethod
import numpy as np
import torch
import torchvision

V_THR = 1.0 # Spike threshold voltage.
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
BATCH_SIZE = 500
TAU_CURR = 1e-3 # time constant for current decay

class BaseSpkNeuron(object):
  def __init__(self, n_neurons):
    """
    Args:
      n_neurons: Number of spiking neurons.
      v_thr <int>: Threshold voltage.
    """
    self._v = torch.zeros(BATCH_SIZE, n_neurons, device=DEVICE) # matrix of IF neurons
    self._v_thr = torch.as_tensor(V_THR)

  def update_voltage(self, c):
    """
    Args:
      c <float>: Current input to update the voltage.
    """
    if c.shape != self._v.shape:
        print("c:", c.shape)
        print("v:", self._v.shape)
    self._v = self._v + c
    mask = self._v < 0 # Mask to rectify the voltage if negative.
    self._v[mask] = 0

  def re_initialize_voltage(self):
    """
    Resets all the neurons' voltage to zero.
    """
    self._v = torch.zeros_like(self._v)

  def reset_voltage(self, spikes):
    """
    Reset the voltage of the neurons which spiked to zero.
    """
    mask = spikes.detach() > 0
    self._v[mask] = 0

  @abstractmethod
  def spike_and_reset_voltage(self):
    """
    Abstract method to be mandatorily implemented for the neuron to spike and 
    reset the voltage.
    """
    raise NotImplementedError


