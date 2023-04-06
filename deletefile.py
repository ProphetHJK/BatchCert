import os

def delete_files(directory, filename):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file == filename:
                os.remove(os.path.join(root, file))

dir1 = './cert'
filename = 'device.crt'
delete_files(dir1,filename)