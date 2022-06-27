# Dockerfile for ThinkStats

FROM rocker/tidyverse
MAINTAINER Russ Poldrack <poldrack@gmail.com>

RUN sudo apt-get clean all
RUN sudo apt-get update
RUN sudo apt-get dist-upgrade -y
RUN sudo apt-get autoremove
RUN apt-get install -y make git ssh
RUN apt-get install  -y jags
RUN apt-get install -y gsl-bin libgsl-dev libv8-dev
RUN apt-get install  -y libudunits2-0
RUN apt-get install -y tex-common texlive-base texlive-latex-recommended \
                 texlive-latex-extra texlive-fonts-recommended latex-cjk-all
# RUN apt-get install -y texlive-full
RUN apt-get install -y libudunits2-dev
RUN apt-get install -y libgdal-dev
RUN apt-get install -y librsvg2-dev
RUN apt-get install -y libglpk-dev
RUN apt-get install -y libtesseract-dev tesseract-ocr-eng libpoppler-cpp-dev libmagick++-dev cargo libavfilter-dev 
RUN apt-get install -y libharfbuzz-dev libfribidi-dev
RUN apt-get install -y vim

# installing R packages
# NOTE: don't use apt-get to install R packages, see https://hub.docker.com/r/rocker/tidyverse
# this assumes that "make pkgsetup" has been run already
# first install rspm
RUN sudo apt-get install -y gdebi-core
RUN wget https://cdn.rstudio.com/package-manager/ubuntu20/amd64/rstudio-pm_2022.04.0-7_amd64.deb
RUN sudo gdebi -n rstudio-pm_2022.04.0-7_amd64.deb

ADD setup/package_installs.R /tmp/package_installs.R

RUN Rscript /tmp/package_installs.R

# fiftystater was removed from CRAN so must be installed from the archive

RUN echo 'install.packages("https://cran.r-project.org/src/contrib/Archive/fiftystater/fiftystater_1.0.1.tar.gz",\
  repos=NULL,dependencies=TRUE)' > /tmp/packages2.R  && Rscript /tmp/packages2.R

CMD ["/bin/bash"]
