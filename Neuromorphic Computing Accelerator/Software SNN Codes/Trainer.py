import torch 
import torchvision
import numpy as np
from DenseSNN import DenseSNN
from tqdm import tqdm

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
BATCH_SIZE = 500

class TrainEvalDenseSNN(object):
  def __init__(self, n_ts=25, epochs=20):
    """
    Args:
      n_ts <int>: Number of time-steps to present each image for training/test.
      epochs <int>: Number of training epochs.
    """
    self.epochs = epochs
    self.loss_function = torch.nn.CrossEntropyLoss()
    self.model = DenseSNN(n_ts=n_ts).to(DEVICE) # n_ts = presentation time-steps.
    self.optimizer = torch.optim.Adam(self.model.parameters(), lr=1e-3)

    # Get the Train- and Test- Loader of the MNIST dataset.
    self.train_loader = torch.utils.data.DataLoader(
        torchvision.datasets.MNIST(root='./data', train=True, download=True,
                      transform=torchvision.transforms.Compose([
    # ToTensor transform automatically converts all image pixels in range [0, 1].
                          torchvision.transforms.ToTensor()
                          ])
                      ),
        batch_size=BATCH_SIZE, shuffle=True)
    self.test_loader = torch.utils.data.DataLoader(
        torchvision.datasets.MNIST(root='./data', train=False, download=True, 
                       transform=torchvision.transforms.Compose([
    # ToTensor transform automatically converts all image pixels in range [0, 1].
                           torchvision.transforms.ToTensor()
                           ])
                      ),
        batch_size=BATCH_SIZE, shuffle=True)

  def train(self, epoch):
    all_true_ys, all_pred_ys = [], []
    all_batches_loss = []
    self.model.train()
    for trn_x, trn_y in tqdm(self.train_loader):
      # Each batch trn_x and trn_y is of shape (BATCH_SIZE, 1, 28, 28) and 
      # (BATCH_SIZE) respectively, where the image pixel values are between 
      # [0, 1], and the image class is a numeral between [0, 9].
      trn_x = trn_x.flatten(start_dim=1).to(DEVICE) # Flatten from dim 1 onwards.
      all_ts_out_spks = self.model(trn_x) # Output = (BATCH_SIZE, n_ts, #Classes).
      mean_spk_rate_over_ts = torch.mean(all_ts_out_spks, axis=1) # Mean over time-steps.
      # Shape of mean_spk_rate_all_ts is (BATCH_SIZE, #Classes).
      trn_preds = torch.argmax(mean_spk_rate_over_ts, axis=1) # ArgMax over classes.
      # Shape of trn_preds is (BATCH_SIZE,).
      all_true_ys.extend(trn_y.detach().numpy().tolist())
      all_pred_ys.extend(trn_preds.detach().numpy().tolist())

      # Compute Training Loss and Back-propagate.
      loss_value = self.loss_function(mean_spk_rate_over_ts, trn_y)
      all_batches_loss.append(loss_value.detach().item())
      self.optimizer.zero_grad()
      loss_value.backward()
      self.optimizer.step()
    
    trn_accuracy = np.mean(np.array(all_true_ys) == np.array(all_pred_ys))
    return trn_accuracy, np.mean(all_batches_loss)

  def eval(self, epoch):
    all_true_ys, all_pred_ys = [], []
    self.model.eval()
    all_images, all_labels = [], []
    with torch.no_grad():
      i = 0
      for tst_x, tst_y in tqdm(self.test_loader):
        i += 1
      # Each batch tst_x and tst_y is of shape (BATCH_SIZE, 1, 28, 28) and 
      # (BATCH_SIZE) respectively, where the image pixel values are between 
      # [0, 1], and the image class is a numeral between [0, 9].
        tst_x = tst_x.flatten(start_dim=1).to(DEVICE) # Flatten from dim 1 onwards.

        temp = tst_x.detach().cpu().numpy()
        all_images.extend(temp)
        # np.savetxt(f'input_data_{i}.txt', temp)
        temp = tst_y.detach().cpu().numpy()
        all_labels.extend(temp)
        # np.savetxt(f'input_labels_{i}.txt', temp)

        all_ts_out_spks = self.model(tst_x)
        mean_spk_rate_over_ts = torch.mean(all_ts_out_spks, axis=1)
        tst_preds = torch.argmax(mean_spk_rate_over_ts, axis=1)
        all_true_ys.append(tst_y.detach().numpy().tolist())
        all_pred_ys.append(tst_preds.detach().numpy().tolist())
    
    all_images = np.array(all_images)
    all_labels = np.array(all_labels)
    np.savetxt('input_data.txt', all_images)
    np.savetxt('input_labels.txt', all_labels)
      
    tst_accuracy = np.mean(np.array(all_true_ys) == np.array(all_pred_ys))
    return tst_accuracy

  def train_eval(self):
    for epoch in range(1, self.epochs+1):
      _, mean_loss = self.train(epoch)
      tst_accuracy = self.eval(epoch)
      if epoch == 1:
        best_accuracy = tst_accuracy
      else:
        if tst_accuracy > best_accuracy:
          best_accuracy = tst_accuracy
          torch.save(self.model.state_dict(), './best_model.pth')
      print("Epoch: %s, Training Loss: %s, Test Accuracy: %s" 
            % (epoch, mean_loss, tst_accuracy))
  
  def test(self):
    self.model.load_state_dict(torch.load('./best_model.pth'))
    tst_accuracy = self.eval(epoch=None)
    print("Test Accuracy: %s" % (tst_accuracy))