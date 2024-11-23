#! /usr/bin/python3
# -*- coding: utf-8 -*-
# item song from The Legend of Zelda: Ocarina of Time

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import plotly.plotly as py
import numpy as np
from math import cos, sin, pi, pow, exp, log, floor, sqrt
import pyaudio
import scipy.io.wavfile


PyAudio = pyaudio.PyAudio

# bit rate = (sample rate) * (bit depth) * (channels)
# 352800 = 44100 * 8 * 1

# technical values
C = 1
R = 44100 # sample/s
B = 8 # bits
D = (1 << B) - 1 # sample max value

SCALE = (262,277,294,311,330,349,370,392,415,440,466,494)
SCALE_COUNT = len(SCALE)
DURATION = 150 # ms

plot_bool = False
play_bool = False

def inc_whole (note, octave):
    if note < (SCALE_COUNT - 2):
        note += 2
    elif note == (SCALE_COUNT - 2):
        note = 0
        octave += 1
    else:
        note = 1
        octave += 1
    return note, octave


def inc_half (note, octave):
    if (note < (SCALE_COUNT - 1)):
        note += 1
    else:
        note = 0
        octave += 1
    return note, octave


def dec_whole (note, octave):
    if note >= (2):
        note -= 2
    elif note == (2):
        note = 0
        octave -= 1
    else:
        note = SCALE_COUNT - 1
        octave -= 1
    return note, octave


def dec_half (note, octave):
    if (note >= (1)):
        note -= 1
    else:
        note = SCALE_COUNT - 1
        octave -= 1
    return note, octave


def beep (frequency, duration):
    #print('{:4} {:4}'.format(frequency, duration))
    return [frequency]*int((R*duration)/1000)


def play_note (note, octave, duration):
    return beep((SCALE[note] << octave), duration)


def play_pause (duration):
    return beep(0, duration)


def play_inc_quadruplet (note, octave):
    freq = []
    for i in range(4):
        freq.extend(play_note(note, octave, DURATION))
        note, octave = inc_whole(note, octave)
    #print('')
    return freq

def play_dec_quadruplet (note, octave):
    freq = []
    for i in range(4):
        freq.extend(play_note(note, octave, DURATION))
        note, octave = dec_whole(note, octave)
    #print('')
    return freq

# setup
note   = 4 # index for SCALE
octave = 2 # octave
frequency = []

for i in range(4):
    frequency.extend(play_dec_quadruplet(note, octave))
    frequency.extend(play_dec_quadruplet(note, octave))
    note, octave = dec_half(note, octave)
for i in range(4):
    frequency.extend(play_dec_quadruplet(note, octave))
    note, octave = dec_half(note, octave)
frequency.extend(play_pause(DURATION*4))
note, octave = dec_whole(note, octave)
note, octave = dec_whole(note, octave)
note, octave = dec_whole(note, octave)
for i in range(3):
    frequency.extend(play_note(note, octave, DURATION*2))
    note, octave = dec_half(note, octave)
frequency.extend(play_note(note, octave, DURATION*4))


# normalized sinusoid waveform
delta_phase = [(2. * pi * f / R) for f in frequency]
phase = list(np.cumsum(delta_phase))
N = len(phase)
sinusoid1 = [(1. - cos(phase[i])) / 2. for i in range(N)]

note   = 4 # index for SCALE
octave = 0 # octave
frequency = []

for i in range(4):
    frequency.extend(play_inc_quadruplet(note, octave))
    frequency.extend(play_inc_quadruplet(note, octave))
    note, octave = inc_half(note, octave)
for i in range(4):
    frequency.extend(play_inc_quadruplet(note, octave))
    note, octave = inc_half(note, octave)
frequency.extend(play_pause(DURATION*4))
note, octave = inc_whole(note, octave)
note, octave = inc_whole(note, octave)
note, octave = inc_whole(note, octave)
#print('')
for i in range(3):
    frequency.extend(play_note(note, octave, DURATION*2))
    note, octave = inc_half(note, octave)
frequency.extend(play_note(note, octave, DURATION*4))


# normalized sinusoid waveform
delta_phase = [(2. * pi * f / R) for f in frequency]
phase = list(np.cumsum(delta_phase))
N = len(phase)
print(N)
sinusoid2 = [(1. - cos(phase[i])) / 2. for i in range(N)]

# samples
samples = [int(D * (sinusoid1[i]) / 2) for i in range(N)]
WAVEDATA = ''.join([chr(s) for s in samples]) # binary data
print(max(samples))
scipy.io.wavfile.write('item.wav', R, np.array(samples, 'u1'))

# time in sec
t = [1.*i/R for i in range(N)]

if plot_bool:
    print('Plotting...')

    lw = 0.75
    pc = 5
    p = 1
    
    print(p)
    ax1 = plt.subplot(pc,1,p)
    ax1.plot(t,frequency, linewidth=lw)
    ax1.set_yscale('log')
    ax1.set_ylabel('f')
    p += 1
    
    print(p)
    ax = plt.subplot(pc,1,p, sharex=ax1)
    ax.plot(t,phase, linewidth=lw)
    ax.set_ylabel('theta')
    p += 1
    
    print(p)
    ax = plt.subplot(pc,1,p, sharex=ax1)
    ax.plot(t,sinusoid, linewidth=lw)
    ax.set_ylim(-0.1, 1.1)
    ax.set_ylabel('s')
    p += 1
    
    print(p)
    ax = plt.subplot(pc,1,p, sharex=ax1)
    ax.plot(t,samples, linewidth=lw)
    ax.set_ylim(0, D+1)
    ax.set_yticks([0, (D+1)//2, D+1])
    ax.grid(True)
    ax.set_ylabel('S')
    p += 1
    
    print(p)
    ax = plt.subplot(pc,1,p, sharex=ax1)
    Pxx, freqs, bins, im = ax.specgram(samples, Fs=R)
    #Pxx, freqs, bins = mlab.specgram(samples, Fs=R)
    #ax.pcolor(bins, freqs, Pxx)
    ax.set_yscale('log')
    ax.set_ylabel('f')
    ax.set_xlabel('t')
    ax.set_ylim(200., 1000.)
    p += 1
    
    print(p)
    plt.show()


if play_bool:
    print('Playing...')
    p = PyAudio()
    stream = p.open(format   = p.get_format_from_width(1),
                    channels = 1, 
                    rate     = R,
                    output   = True)
    stream.write(WAVEDATA)
    stream.stop_stream()
    stream.close()
    p.terminate()
