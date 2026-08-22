from Trainer import TrainEvalDenseSNN
if __name__ == "__main__":
    trainer = TrainEvalDenseSNN(n_ts=25, epochs=20)
    # trainer.train_eval()
    trainer.test()