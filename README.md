# ndb_covid_infection

Research for impact on medical resource usage by Covid-19 in Japan.

Here we deposit Rmarkdowns, sql files and outputs used this project.



# Materials and methods
process is described at protocol io.  
DOI: dx.doi.org/10.17504/protocols.io.eq2lyj34qlx9/v1  


# analysis steps

Analysis environment is described by "SessionInfo" function at last part of htmls. Used packages are listed up at the section.  
Description of each file and the purpose.  

- Ps001_create_schema  
    - create local postgres.  
    - some select sql files are written in this folder.  

- Ps002_02_create_hoko
    - create cost tables integrated insurance and public payments.  
    - This project uses dpc, med, pha.  
    - Dental recoerds are not included.  

- CD SI long, IY long
    - duplication in CD and IY, SI is checked by new tag, dup_flg_2.  

    - When there are m of records such as seq2_no: A, date of usage: B, code of drug or proceduer: C, dose or amount:D, usage times: E, practical indentity: F in CD,  
    - and there are n of records such as seq2_no: A, date of usage: B, code of drug or proceduer: C, dose or amount:D, usage times: E, practical indentity: F in IY or SI,  

    - We consider which min(m, n) for records in CD is duplicated.  
    - Then dup_flg_2 =1  

- Ps002_create_whole_db
    - bulk insert from redshift.  

- Ps003_covid_pts_dist
    - evaluation of covid patients distribution.  

- Ps004_cvd_adm_dist
    - evaluation of usage of clinical proceduere.  

- Ps005_drug_usesage
    - evaluation of drug usages.

- Ps06_assay_dist
    - evaluation of assay usages.

- Ps002_02_ho_dist
    - evaluation of cost.

- Ps07_extra_dis_dist 
    - relation with other respiratory viral infection.

- S148_covid_dis_timeseries
    - data from HER-SYS

- S231_yen_2_daller
    - data from "日本銀行時系列統計データ検索サイト"
    - https://www.stat-search.boj.or.jp/ssi/mtshtml/fm08_m_1.html

- S234_wave_definition
    - wave difinition from covid pts dist




# License
GPL v3 about our codes.
