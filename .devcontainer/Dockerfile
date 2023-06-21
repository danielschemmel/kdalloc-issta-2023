# syntax=docker.io/docker/dockerfile:1.4

FROM docker.io/library/ubuntu:22.04 AS build
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		build-essential \
		cmake \
		ninja-build \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
	

# MINISAT

FROM docker.io/alpine/git AS minisat-src
RUN git clone https://github.com/stp/minisat.git /minisat \
	&& git -C /minisat gc --aggressive

FROM build AS minisat-build-deps
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		zlib1g-dev \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/

FROM minisat-build-deps AS minisat-build
COPY --from=minisat-src /minisat /minisat
RUN mkdir -p /minisat/build \
	&& cd /minisat/build \
	&& cmake -GNinja \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=TRUE \
		-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=gold \
		-DCMAKE_INSTALL_PREFIX=/usr/local/ \
		..
RUN ninja -C /minisat/build/

FROM minisat-build AS minisat-package
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		file \
		git \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
RUN cd /minisat/build \
	&& cpack -G DEB -P minisat -R 0.git-$(git rev-parse HEAD --short=16) \
		-D CPACK_CMAKE_GENERATOR=Ninja \
		-D CPACK_PACKAGING_INSTALL_PREFIX=/usr/local \
		-D CPACK_INSTALL_CMAKE_PROJECTS='/minisat/build;minisat;ALL;/' \
		-D CPACK_PACKAGE_NAME='minisat-git' \
		-D CPACK_PACKAGE_FILE_NAME='minisat' \
		-D CPACK_PACKAGE_DESCRIPTION='The minisat constraint solver' \
		-D CPACK_PACKAGE_CONTACT=root \
		-D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON

FROM docker.io/library/ubuntu:22.04 as minisat
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	--mount=type=bind,from=minisat-package,target=/minisat,source=/minisat \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		/minisat/build/minisat.deb \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
# docker buildx might leave these directories behind, but podman does not
RUN rmdir /minisat || true


# CRYPTOMINISAT

FROM docker.io/alpine/git AS cryptominisat-src
ARG cryptominisat_version=5.11.4
RUN git clone https://github.com/msoos/cryptominisat /cryptominisat --branch ${cryptominisat_version} \
	&& git -C /cryptominisat gc --aggressive

FROM build AS cryptominisat-build-deps
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		libboost-program-options-dev \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/

FROM cryptominisat-build-deps AS cryptominisat-build
COPY --from=cryptominisat-src /cryptominisat /cryptominisat
RUN mkdir -p /cryptominisat/build \
	&& cd /cryptominisat/build \
	&& cmake -GNinja \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=TRUE \
		-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=gold \
		-DCMAKE_INSTALL_PREFIX=/usr/local/ \
		..
RUN ninja -C /cryptominisat/build/

FROM cryptominisat-build AS cryptominisat-package
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		file \
		git \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
RUN cd /cryptominisat/build \
	&& cpack -G DEB -P cryptominisat -R 0.git-$(git rev-parse HEAD --short=16) \
		-D CPACK_CMAKE_GENERATOR=Ninja \
		-D CPACK_PACKAGING_INSTALL_PREFIX=/usr/local \
		-D CPACK_INSTALL_CMAKE_PROJECTS='/cryptominisat/build;cryptominisat;ALL;/' \
		-D CPACK_PACKAGE_NAME='cryptominisat-git' \
		-D CPACK_PACKAGE_FILE_NAME='cryptominisat' \
		-D CPACK_PACKAGE_DESCRIPTION_SUMMARY='The cryptominisat constraint solver' \
		-D CPACK_PACKAGE_DESCRIPTION='The cryptominisat constraint solver' \
		-D CPACK_PACKAGE_CONTACT=root \
		-D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON

FROM docker.io/library/ubuntu:22.04 as cryptominisat
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	--mount=type=bind,from=cryptominisat-package,target=/cryptominisat,source=/cryptominisat \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		/cryptominisat/build/cryptominisat.deb \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
# docker buildx might leave these directories behind, but podman does not
RUN rmdir /cryptominisat || true


# STP

FROM docker.io/alpine/git AS stp-src
ARG stp_version=master
RUN git clone https://github.com/stp/stp.git /stp --branch ${stp_version} \
	&& git -C /stp gc --aggressive

FROM build AS stp-build-deps
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	--mount=type=bind,from=minisat-package,target=/minisat,source=/minisat \
	--mount=type=bind,from=cryptominisat-package,target=/cryptominisat,source=/cryptominisat \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		cmake \
		bison \
		flex \
		libboost-all-dev \
		python-is-python3 \
		perl \
		zlib1g-dev \
		/minisat/build/minisat.deb \
		/cryptominisat/build/cryptominisat.deb \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
# docker buildx might leave these directories behind, but podman does not
RUN rmdir /minisat /cryptominisat || true

FROM stp-build-deps AS stp-build
COPY --from=stp-src /stp /stp
RUN mkdir -p /stp/build \
	&& cd /stp/build \
	&& cmake -GNinja \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=TRUE \
		-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=gold \
		-DCMAKE_INSTALL_PREFIX=/usr/local/ \
		..
RUN ninja -C /stp/build/

FROM stp-build AS stp-package
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		file \
		git \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
RUN cd /stp/build \
	&& cpack -G DEB -P stp -R 0.git-$(git rev-parse HEAD --short=16) \
		-D CPACK_CMAKE_GENERATOR=Ninja \
		-D CPACK_PACKAGING_INSTALL_PREFIX=/usr/local \
		-D CPACK_INSTALL_CMAKE_PROJECTS='/stp/build;stp;ALL;/' \
		-D CPACK_PACKAGE_NAME='stp-git' \
		-D CPACK_PACKAGE_FILE_NAME='stp' \
		-D CPACK_PACKAGE_DESCRIPTION='The STP constraint solver' \
		-D CPACK_PACKAGE_CONTACT=root \
		-D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON

FROM docker.io/library/ubuntu:22.04 as stp
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	--mount=type=bind,from=minisat-package,target=/minisat,source=/minisat \
	--mount=type=bind,from=cryptominisat-package,target=/cryptominisat,source=/cryptominisat \
	--mount=type=bind,from=stp-package,target=/stp,source=/stp \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		/minisat/build/minisat.deb \
		/cryptominisat/build/cryptominisat.deb \
		/stp/build/stp.deb \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
# docker buildx might leave these directories behind, but podman does not
RUN rmdir /minisat /cryptominisat /stp || true


# KLEE-UCLIBC

FROM docker.io/alpine/git AS klee-uclibc-src
RUN git clone https://github.com/klee/klee-uclibc.git /klee-uclibc \
	&& git -C /klee-uclibc gc --aggressive

FROM build AS klee-uclibc-build-deps
ARG LLVM=14

RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		clang-${LLVM} \
		curl \
		llvm-${LLVM}-dev \
		python-is-python3 \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/

FROM klee-uclibc-build-deps AS klee-uclibc-build
ARG LLVM=14

COPY --from=klee-uclibc-src /klee-uclibc /klee-uclibc
RUN cd /klee-uclibc \
	&& ./configure --with-llvm-config=$(which llvm-config-${LLVM}) --make-llvm-lib
RUN make -C /klee-uclibc -j2


# KLEE

FROM docker.io/alpine/git AS klee-src
RUN git clone https://github.com/klee/klee /klee \
	&& git -C /klee gc --aggressive

FROM build AS klee-build-deps
ARG LLVM=14

COPY --from=klee-uclibc-build /klee-uclibc /klee-uclibc
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		clang-${LLVM} \
		libcap-dev \
		libgoogle-perftools-dev \
		libgtest-dev \
		libsqlite3-dev \
		libz3-dev \
		llvm-${LLVM}-dev \
		pipx \
		python3-tabulate \
		zlib1g-dev \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
RUN --mount=type=cache,sharing=locked,target=/root/.cache/pip/,id=ubuntu:22.04/root/.cache/pip/ \
	PIPX_HOME=/usr/local/pipx PIPX_BIN_DIR=/usr/local/bin pipx install lit
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	--mount=type=bind,from=minisat-package,target=/minisat,source=/minisat \
	--mount=type=bind,from=cryptominisat-package,target=/cryptominisat,source=/cryptominisat \
	--mount=type=bind,from=stp-package,target=/stp,source=/stp \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		/minisat/build/minisat.deb \
		/cryptominisat/build/cryptominisat.deb \
		/stp/build/stp.deb \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/
# docker buildx might leave these directories behind, but podman does not
RUN rmdir /minisat /cryptominisat /stp || true

FROM klee-build-deps AS klee-dev
ARG LLVM=14

RUN --mount=type=cache,sharing=locked,target=/root/.cache/pip/,id=ubuntu:22.04/root/.cache/pip/ \
	PIPX_HOME=/usr/local/pipx PIPX_BIN_DIR=/usr/local/bin pipx install wllvm
ENV LLVM_COMPILER=clang LLVM_COMPILER_PATH=/usr/lib/llvm-${LLVM}/bin/
RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt/,id=ubuntu:22.04/var/cache/apt/ \
	--mount=type=cache,sharing=locked,target=/var/lib/apt/lists/,id=ubuntu:22.04/var/lib/apt/lists/ \
	mv /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-gzip-indexes / \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		bash-completion \
		clang-format \
		doxygen \
		file \
		gdb \
		git \
		graphviz \
		lldb \
		ssh \
		sudo \
		vim \
	&& mv /docker-clean /docker-gzip-indexes /etc/apt/apt.conf.d/

ENV PATH=$LLVM_COMPILER_PATH:$PATH

RUN <<DONE
	set -eu
	git clone https://github.com/srg-imperial/kdalloc-issta-2023 /klee-src
	mkdir /klee-build
	cd /klee-build
	cmake -GNinja \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=TRUE \
		-DCMAKE_EXE_LINKER_FLAGS='-fuse-ld=gold -Wl,-L/usr/local/lib' \
		-DCMAKE_INSTALL_PREFIX=/usr/local/ \
		-DKLEE_UCLIBC_PATH=/klee-uclibc \
		-DENABLE_POSIX_RUNTIME=TRUE \
		-DENABLE_UNIT_TESTS=ON \
		/klee-src
	ninja install
DONE

RUN <<DONE
	set -eu
	git clone --filter=blob:none --no-checkout --depth 1 --sparse -b llvmorg-14.0.6 https://github.com/llvm/llvm-project.git /kdalloc-asan
	cd /kdalloc-asan
	git sparse-checkout add cmake compiler-rt llvm/cmake runtimes libcxx libcxxabi llvm/utils/llvm-lit
	git checkout
	git apply < /klee-src/tools/kdalloc-asan/asan-llvm14.0.6.patch
	mkdir build
	cd build
	cmake -GNinja \
    -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=$(clang -dumpmachine) \
    -DKLEE_INCLUDE_DIR=/klee-src/include \
    -DKDALLOC_ASAN_LIB_DIR=/klee-build/lib \
    ../compiler-rt
	ninja
DONE

ARG USERNAME=user
ARG GROUPNAME=${USERNAME}
ARG UID=1000
ARG GID=${UID}

RUN \
	groupadd -g ${GID} ${GROUPNAME} \
	&& useradd -m --uid ${UID} --gid ${GID} -G sudo -s /bin/bash ${USERNAME} \
	&& echo %sudo ALL=\(ALL:ALL\) NOPASSWD:ALL > /etc/sudoers.d/nopasswd \
  && chmod 0440 /etc/sudoers.d/nopasswd