# Printer-size-set-correction
A simple Bash Script to set Printer page default size for mac computers, where the default page size is causing issues.

This is intended for network administrators to allow them to easily and quickly fix page size issues on many computers, without the need to go into cups, or have elevated permissions.


Notes: (For users who are unclear on how this works)
  This is to be run after the printer is installed.
  The printer name will need to include one of the strings indicated as the first paramiter to the set_paper_size call at the bottom of the file.
    If your naming scheme for your printers differs you will need to update the regex so that it can find matches
  When initally saved this script will not have execute premissions, so you will need to use the command "chmod -x <filename>" to allow it to run
    you can then run it by navigating navigating to the folder it is in in the Terminal can typing "./<filename>"

    
  The current version is configured to only work with Konica Minolta and Xerox printers with standard names.
  If you want to use this for other printers you will need to update the regex at the bottom of the page. (First paramiter of the set_paper_size function)

  
  This can be updated to set other options, but keep in mind that many printer options are printer or driver specific
    to find out supported options you can use "lpoptions -p <printer_name> -l" then add the options you want set into line 39, keep in mind that this script only checks paper size.
      So if the paper size already matches it will not update the other options.
        If you want those options checked as well you may need to have the add another variable similar to current, then add it to the check on line 37
