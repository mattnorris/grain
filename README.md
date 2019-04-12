# Grain

**Grain** is a simplified [SaltStack](http://www.saltstack.com/) for personal configuration management. It is an alternative without the steep learning curve when you need to manage your local utilities in the simplest way. 

# Example 

    gen_install_script.py mysql 
    
Where *mysql* is the tool you wish to install and uninstall. 

## Output 

    $HOME/install-mysql.sh
    
A bash script skeleton; fill in the `installPackages` and `removePackages` with the commands to install and remove the desired packages for the tool (in this case, mysql). 

See [install-mysql.sh](https://github.com/mattnorris/grain/blob/master/src/install-mysql.sh) and other scripts for examples and details. 

# Options 

# -d 

Specifies the directory to save to or the filename to save as. 

    gen_install_script.py mysql -d $HOME/homesubdir
    
# -f

By default, Grain warns you of duplicate filenames. This forces a file overwrite. 

    gen_install_script.py mysql -f 
    
