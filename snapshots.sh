#On a rhino server you should be able to recover the and older version of the 3.6 all the way back to the 15th of October.

cd ~/.snapshots
ls -la

#What you should see here is a daily/ hourly snapshot of your home folder. I would recommand backing up your current 3.6 folder with the following command

mv /home/jlsmith3/R/ x86_64-pc-linux-gnu-library/3.6     /home/jlsmith3/R/ x86_64-pc-linux-gnu-library/3.6.bak

#Then copying  a snapshot version of the 3.6 folder to  /home/jlsmith3/R/ x86_64-pc-linux-gnu-library

#For example, if you wanted to restore the 3.6 folder back to its state on November 1 you would run these commands.

mv /home/jlsmith3/R/ xR86_64-pc-linux-gnu-library/3.6      /home/jlsmith3/R/ x86_64-pc-linux-gnu-library/3.6.bak

cp -prf /home/jlsmith3/.snapshot/daily.2019-11-01_0010/R/x86_64-pc-linux-gnu-library/3.6   /home/jlsmith3/R/ xR86_64-pc-linux-gnu-library/.
