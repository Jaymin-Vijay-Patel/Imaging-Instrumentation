function [ t ] = find_t( m, n, p, q )
%FIND_T Summary of this function goes here
%   Detailed explanation goes here
ts = [(n-m)' (p-q)'] \ (p-m)';
t = ts(1);
end

