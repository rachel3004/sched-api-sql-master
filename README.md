Make a EC2 instance

Clone repo*
	in order to clone the repo you might need to generate a ssh key for the server
	just run ssh-keygen and ‘Enter’ accepting all defaults.

	then copy the content of ~/.ssh/id_rsa.pub and add it as a “Deployment key” on gitlab

	https://gitlab.com/3abn/sched-api-sql/settings/repository

Make folders on the server:

`mkdir ~/data ~/scripts`

cd sched-api-sql


npm run deploy crontab -e

Add:
19 * * * * ./scripts/UpdateSchedule_Radio.sh
39 * * * * ./scripts/UpdateSchedule_TV.sh


:wq

To write and quit

Then run ‘npm start’ 