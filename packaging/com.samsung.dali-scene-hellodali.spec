%bcond_with wayland

Name:       com.samsung.dali-scene-hellodali
Summary:    Hello world like scene for DALi scene launcher.
Version:    1.0.0
Release:    1
Group:      Scenes for DALi scene launcher
License:    Apache-2.0
URL:        https://github.com/dalihub/dali-scene-template
Source0:    %{name}-%{version}.tar.gz

BuildRequires: cmake

#need libtzplatform-config for directory if tizen version is >= 3.x
BuildRequires: pkgconfig(libtzplatform-config)

BuildRequires: com.samsung.dali-scene-launcher

%description
Basic scene for dali-scene-launcher.

##############################
# Preparation
##############################
%prep
%setup -q

# Defines the destination folders. Use TZ_PATH when tizen version is >= 3.x
%define dali_app_ro_dir         %TZ_SYS_RO_APP/%{name}/
%define smack_rule_dir          %TZ_SYS_SMACK/accesses2.d/
%define dali_xml_file_dir       %TZ_SYS_RO_PACKAGES
%define dali_icon_dir           %TZ_SYS_RO_ICONS

%define dali_app_res_dir        %{dali_app_ro_dir}/res/
%define dali_app_exe_dir        %{dali_app_ro_dir}/bin/
%define dali_app_ico_dir        %{dali_app_ro_dir}/share/icons

# The dali-scene-launcher executable.
%define dali_scene_launcher_exe %TZ_SYS_RO_APP/com.samsung.dali-scene-launcher/bin/dali-scene-launcher

# Defines the model's template name.
%define model_template_name hellodali

##############################
# Build
##############################
%build

cd %{_builddir}/%{name}-%{version}/%{model_template_name}/build/tizen

cmake -DDALI_APP_RES_DIR=%{dali_app_res_dir}

##############################
# Installation
##############################

# This stage prepares all the package contents before the rpm is build.
# The BUILDROOT folder ( %{buildroot} ) has to contain all the files included in the rpm package.
# The BUIL folder %{_builddir} is the expanded tar.gz created from the git repository.
# The preparation consists in execute the cmake command and copy/move other files into the desired folders.

%install
rm -rf %{buildroot}
cd %{model_template_name}/build/tizen
%make_install DALI_APP_RES_DIR=%{dali_app_res_dir}

%if 0%{?enable_dali_smack_rules} && !%{with wayland}
mkdir -p %{buildroot}%{smack_rule_dir}
cp -f %{_builddir}/%{name}-%{version}/%{name}.rule %{buildroot}%{smack_rule_dir}
%endif

# Copy dali-scene-launcher exe file
mkdir -p %{buildroot}/%{dali_app_exe_dir}
cp %{dali_scene_launcher_exe} %{buildroot}/%{dali_app_exe_dir}

# Copy the icon file.
mkdir -p %{buildroot}%{dali_icon_dir}
mv %{_builddir}/%{name}-%{version}/%{model_template_name}/share/icons/%{name}.png %{buildroot}%{dali_icon_dir}

# xml package file
mkdir -p %{buildroot}%{dali_xml_file_dir}
cp -f %{_builddir}/%{name}-%{version}/%{model_template_name}/%{name}.xml %{buildroot}%{dali_xml_file_dir}

##############################
# Files in Binary Packages
##############################

%files
%if 0%{?enable_dali_smack_rules}
%manifest %{model_template_name}/%{name}.manifest-smack
%else
%manifest %{model_template_name}/%{name}.manifest
%endif
%defattr(-,root,root,-)
%{dali_app_res_dir}/images/*
%{dali_app_res_dir}/models/*
%{dali_app_res_dir}/shaders/*
%{dali_app_exe_dir}/*
%{dali_xml_file_dir}/%{name}.xml
%{dali_icon_dir}/*
%license LICENSE
%if 0%{?enable_dali_smack_rules} && !%{with wayland}
%config %{smack_rule_dir}/%{name}.rule
%endif
