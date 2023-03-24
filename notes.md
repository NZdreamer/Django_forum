
## questions when setting up auto-deploy script

### secrect_key

SECRECT_KEY is set in 'setting.py' for Django project. Good practise is to store it seperately instead of writing directly in 'setting.py'. 
Need to add the file storing key to system environment, if using os.environ to access the key.

However, gonicorn will not work if using storing SECRECT_KEY seperately.


### venv directory path

Some commands need to be execute in python virtual environment.

To get into the venv, use `source mymisagoenv/bin/activate`.

But the venv environment directory name depends on the person who set the venv up, so this command may only work for myself.