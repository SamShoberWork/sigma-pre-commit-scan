FROM redhat/ubi8 AS ubi8-cov-analysis

ARG VERSION=2022.12.1
ARG INSTDIR=/opt/coverity/analysis

# copy installation files
COPY cov-analysis-linux64-$VERSION.sh /tmp/
COPY license.dat /tmp/

# install prerequisites
RUN yum install -y freetype

# install Coverity Analysis
RUN sh /tmp/cov-analysis-linux64-$VERSION.sh -q --installation.dir=$INSTDIR \
	--license.region=0 \
	--license.agreement=agree \
	--license.cov.path=/tmp/license.dat \
	--component.sdk=false \
	--component.skip.documentation=true

# reclaim installer space with two-stage docker build
FROM redhat/ubi8
COPY --from=ubi8-cov-analysis /opt/coverity /opt/coverity
ENV PATH=$PATH:/opt/coverity/analysis/bin
