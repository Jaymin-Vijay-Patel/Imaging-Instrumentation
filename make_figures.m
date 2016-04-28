close all
t = 0:.01:10;
figure; hold on
plot(t,sin(2*pi*.9*t));
plot(t,-sin(2*pi*.1*t));
samps = 0:10;
scatter(samps, sin(2*pi*.9*samps), 'o', 'red')
%figure;
%hold on
%plot(t,sin(2*pi*.9*t));
%scatter(samps, sin(2*pi*.9*samps), 'o', 'red')
scatter(samps(1:end-1)+.5, sin(2*pi*.9*(samps(1:end-1)+.5)), 'o', 'green')

%%
fake_shifts = [0 0; 1/6 0; 0 -1/6; 1/6 -1/6];
real_shifts = zeros(4,2);
for ii=1:2
    for jj=1:2
        res = dftregistration(fft2(star_low_005_13x13(600:700,400:500,ii,jj)), fft2(star_low_005_13x13(600:700,400:500,1,1)),100);
        real_shifts(jj+(ii-1)*2,:) = [res(3) res(4)];
    end
end
%%
figure;
hold on
for ii=1:size(fake_shifts,1)
    h = fill([0 1 1 0]+fake_shifts(ii,1),[0 0 1 1]+fake_shifts(ii,2),'r');
    set(h,'facealpha',.3);
end
axis square
