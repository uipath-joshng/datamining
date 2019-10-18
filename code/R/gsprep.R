########################################################
# Prepare a list of accounts with roles unfilled
# Author: Josh <yoshitaka.nagano@uipath.com> 
# Created: Sep 19, 2019
# Updated: Oct 04, 2019
########################################################

#setwd("C:/Users/yoshitaka.nagano.UIPATH/Desktop/gsprep")

# init: dependencies
library(tidyverse)

# init: import datasets from csv files (exported from Salesforce report)
#read_csv("https://uipath.my.salesforce.com/00O1Q000008A7Eq?export=1&enc=UTF-8&xf=csv") #SAML auth required.
contacts.raw <- read_csv("contacts.csv")
bigdeal.raw <- read_csv("bigdeal.csv")
#gscontacts.raw <-read_csv("gscontacts.csv")

# filter bigdeal data table
bigdeal <- bigdeal.raw %>%
  dplyr::select(AccountName = `Account Name`, ExecActSponsor = `Executive Account Sponsor`, TotalAmt = `Total Amount`, bdflag = `bdflag`)
#  dplyr::filter(TotalAmt > 100000) %>%
#  dplyr::distinct(AccountName, .keep_all = TRUE)
#bigdeal <- cbind(bigdeal, bdflag=rep(1, nrow(bigdeal)))

# filter contacts data table
contacts.target <- contacts.raw %>%
  dplyr::select(AccountName = `Account Name`, AccountIdLong = `Account ID Long`, AccountOwner = `Account Owner`, FullName = `Full Name`, FirstNameLocal = `First Name (Local)`, LastNameLocal = `Last Name (Local)`, Role = `Role`, Email = `Email`) %>%
  dplyr::left_join(bigdeal, by="AccountName") %>%
  dplyr::filter(bdflag == 1) %>%
  dplyr::arrange(desc(TotalAmt))

# filter contacts data table
#contacts.remain <- contacts.target %>%
#  dplyr::select(AccountName = `AccountName`, AccountIdLong = `AccountIdLong`, AccountOwner = `AccountOwner`, FullName = `FullName`, FirstNameLocal = `FirstNameLocal`, LastNameLocal = `LastNameLocal`, Role = `Role`, Email = `Email`) %>%
#  dplyr::filter(!Role %in% c("RPA CoE Lead", "RPA Sponsor", "RPA Sponsor & RPA CoE Leader", "RPA Primary Contact")) %>%
#  dplyr::left_join(bigdeal, by="AccountName") %>%
#  dplyr::filter(bdflag == 1) %>%
#  dplyr::distinct(AccountIdLong, .keep_all = TRUE) %>%
#  dplyr::arrange(desc(TotalAmt))

# filter contacts data table
contacts.filled <- contacts.target %>%
  dplyr::select(AccountName = `AccountName`, AccountIdLong = `AccountIdLong`, AccountOwner = `AccountOwner`, FullName = `FullName`, FirstNameLocal = `FirstNameLocal`, LastNameLocal = `LastNameLocal`, Role = `Role`, Email = `Email`) %>%
  dplyr::filter(Role %in% c("RPA CoE Lead", "RPA Sponsor", "RPA Sponsor & RPA CoE Leader", "RPA Primary Contact")) %>%
  dplyr::left_join(bigdeal, by="AccountName") %>%
  dplyr::filter(bdflag == 1) %>%
  dplyr::arrange(desc(TotalAmt))

# export data to csv file
write.csv(contacts.target, file="contacts_target_rcv.csv")
#write.csv(contacts.remain, file="contacts_remaining.csv")
write.csv(contacts.filled, file="contacts_filled.csv")



#gscontacts <- gscontacts.raw %>%
#  dplyr::select(AccountName = `Account Name`, AccountNameLocal = `Account Name (Local)`, Role = `Role`, Title = `Title`, FullName = `Full Name`, FirstNameLocal = `First Name (Local)`, LastNameLocal = `Last Name (Local)`, Email = `Email`) %>%
#  dplyr::filter(Role %in% c("RPA CoE Lead", "RPA Sponsor", "RPA Sponsor & RPA CoE Leader", "RPA Primary Contact")) 
  
# format date in opps data table
#opps.raw$ClosedDate <- strptime(as.character(opps.raw$`Close Date`), "%m/%d/%Y")
#opps.raw$ClosedDate <- as.Date(format(opps.raw$ClosedDate, "%Y-%m-%d"))

# filter & join opps data table
#opps <- opps.raw %>%
#  dplyr::filter(Stage == "Closed Won Booked") %>%
#  dplyr::filter(ClosedDate > as.Date("2018-9-1")) %>%
#  dplyr::select(`Account Name`, `Account ID Long`, `Deal Type`, `ClosedDate`) %>%
#  dplyr::left_join(bigdeal, by="Account Name") %>%
#  dplyr::filter(bdflag == 1) %>%
#  dplyr::distinct(`Account ID Long`, .keep_all = TRUE) %>%
#  dplyr::right_join(contacts2, by="Account Name")

# list of accounts with some role but not applicable for sending surveys
#role.filled <- filter(opps, !is.na(Role))

# list of big deal accounts
#opps.bd <- filter(opps, bdflag==1 & is.na(Role))
#opps.bd$Role <- ""

# export data to csv file
#write.csv(opps2.bd, file="remaining_contacts.csv")
