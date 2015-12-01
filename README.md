### Simple RNN (LSTM) benchmark for Torch and TensorFlow

There a lot of successful convolutional architectures that could be used to benchmark various framework.
Regarding RNN networks, I've taken [LSTM RNN Language Model](http://arxiv.org/pdf/1409.2329v4.pdf) as a fine sample of the class.
Besides, there are vanilla implementations of the model on Torch and TensorFlow, so almost no extra efforts are required ;)

Results below demonstate training speed in Words Per Second (bigger is better). The metric is quite coarse, but still useful.

Framework \ Setup | Small (200 neurons) | Large (1500 neurons)
----------------- | ------------------- | --------------------
Torch (+fblualib) | 5317                | 1179
TensorFlow        | 2623                | 1330

In nutshell, Torch is much faster then TensorFlow for small networks, but a little slower for huge ones.


#### Todo
Add theano & mxnet

#### Benchmark details
The benchmarks are written using [Docker](https://www.docker.com/). Just run ```./run_docker.sh``` from framework's folder. CUDA 7.0 and recent NVidia driver are required.
