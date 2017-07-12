%bcond_with wayland

Name:       com.samsung.dali-pbr-models-template
Summary:    PBR models.
Version:    1.0.0
Release:    1
Group:      PBR models for DALi demo
License:    Apache-2.0
URL:        https://github.com/dalihub/dali-pbr-models-template
Source0:    %{name}-%{version}.tar.gz

BuildRequires:  cmake

#need libtzplatform-config for directory if tizen version is 3.x
%if "%{tizen_version_major}" == "3"
BuildRequires:  pkgconfig(libtzplatform-config)
%endif

%description
Models for the PBR demo

##############################
# Preparation
##############################
%prep
%setup -q

#Use TZ_PATH when tizen version is 3.x

%if "%{tizen_version_major}" == "2"
%define dali_app_ro_dir       /usr/apps/com.samsung.dali-demo/
%else
%define dali_app_ro_dir       %TZ_SYS_RO_APP/com.samsung.dali-demo/
%endif

##############################
# Build
##############################
%build

cd %{_builddir}/%{name}-%{version}/build/tizen

cmake -DDALI_APP_DIR=%{dali_app_ro_dir}

##############################
# Installation
##############################
%install
rm -rf %{buildroot}
cd build/tizen
%make_install DALI_APP_DIR=%{dali_app_ro_dir}

##############################
# Files in Binary Packages
##############################

%files
%defattr(-,root,root,-)
%{dali_app_ro_dir}/images/pbr/*
%{dali_app_ro_dir}/models/pbr/*
%{dali_app_ro_dir}/shaders/pbr/*
%license LICENSE
