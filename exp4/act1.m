% clear everything
clear all
clc

% run simulation for all p values
simOut = sim('sistemaLinearOrdem3', 'SrcWorkspace', 'current');

% extract simulated data
t = simOut.get('yout').get(1).Values.Time;
y = simOut.get('yout').get(1).Values.Data;
[maxes, maxes_index] = max(y);

% define final value
final = 1;

% get overshoot values
M_p_arr = arrayfun(@(x) (x - final) / final, maxes);

% find p that gives maximum overshoot
p = linspace(.1, 1.2, 50);
M_p_max = max(M_p_arr);
M_p_max_index = find(M_p_arr == M_p_max);
p_max = p(M_p_max_index);

% find the time where the overshoot happens
maxes_t = arrayfun(@(x) t(x), maxes_index);
t_max = maxes_t(M_p_max_index);

% find rising time
y_max = y(:, M_p_max_index);
bigger_than_final = find(y_max >= final);
t_s = t(bigger_than_final(1));

% get accomodation time
percentage_of_final = abs((y_max - final) / final);
bigger_than_2percent = find(percentage_of_final >= 0.02);
t_a = t(bigger_than_2percent(end));

% find values of p such that overshoot <= 0.07
interval = find(M_p_arr <= 0.07 & M_p_arr > 0.01);
p_dot7_first = p(interval(1));
p_dot7_last = p(interval(end));

% transfer function
numerator = 18;
denominator = [1, 2 + 6 * p_dot7_first, 9 + 12 * p_dot7_first, 18, 0];
poles = pole(tf(numerator, denominator));

% find values of p that have no overshoot
interval = find(M_p_arr <= 0.01);
p_noovershoot_first = p(interval(1));
p_noovershoot_last = p(interval(end));
