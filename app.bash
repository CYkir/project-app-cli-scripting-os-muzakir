#!/bin/bash

#WARNA ANSI
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"


default_scale=2
pengaturan_bc="scale=$default_scale"

pilihan=""

# Batas kategori BMI
batas_bawah=(18.5 25.0 30.0)

# Nama kategori sesuai range
kategori=("Kekurangan Berat Badan" "Normal" "Kelebihan Berat Badan" "Obesitas")


#validasi input
validasi_angka() {
    local input="$1"

    # input tidak boleh kosong
    if [[ -z "$input" ]]; then
        echo "empty"
        return
    fi

    # Harus angka / decimal
    if ! [[ "$input" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "notnumber"
        return
    fi

    # Harus lebih dari 0
    if (( $(echo "$input <= 0" | bc -l) )); then
        echo "lessthanzero"
        return
    fi

    echo "ok"
}

#menu
tampilkan_menu() {
  echo -e "\n${CYAN}===================================${RESET}"
  echo -e "${CYAN}         BMI INDEX CALCULATOR       ${RESET}"
  echo -e "${CYAN}===================================${RESET}"
  echo -e "${CYAN}1.${RESET} Hitung BMI Baru"
  echo -e "${CYAN}2.${RESET} Keluar"
  echo -ne "${YELLOW}Pilih Opsi (1/2): ${RESET}"
}


#perhitungan_BMI
hitung_bmi() {
  berat_kg=$1
  tinggi_cm=$2

  #konversi CM -> M
  tinggi_m=$(echo "$pengaturan_bc; $tinggi_cm / 100" | bc -l)

  #rumus_BMI
  bmi=$(echo "$pengaturan_bc; $berat_kg / ($tinggi_m * $tinggi_m)" | bc -l)

  echo "$bmi"
}



#klasifikasi Kategori
klasifikasi_bmi() {
  nilai_bmi=$1

  if (( $(echo "$nilai_bmi >= ${batas_bawah[2]}" | bc -l) )); then
      echo "${kategori[3]}"
  elif (( $(echo "$nilai_bmi >= ${batas_bawah[1]}" | bc -l) )); then
      echo "${kategori[2]}"
  elif (( $(echo "$nilai_bmi >= ${batas_bawah[0]}" | bc -l) )); then
      echo "${kategori[1]}"
  else
      echo "${kategori[0]}"
  fi
}



#input dan perhitungan bmi
proses_hitungan() {
  echo -e "\n${BLUE}==========================="
  echo    "          Input Data            "
  echo -e "===========================${RESET}"

  # Validasi input berat badan
  while true; do
      read -p "Masukkan Berat Badan (kg): " berat_kg
      cek=$(validasi_angka "$berat_kg")

      case $cek in
          ok) break ;;
          empty) echo -e "${RED}Input tidak boleh kosong!${RESET}" ;;
          notnumber) echo -e "${RED}Input harus berupa angka!${RESET}" ;;
          lessthanzero) echo -e "${RED}Nilai tidak boleh kurang atau sama dengan 0!${RESET}" ;;
      esac
  done

  # Validasi input tinggi
  while true; do
      read -p "Masukkan Tinggi Badan (cm): " tinggi_cm
      cek=$(validasi_angka "$tinggi_cm")

      case $cek in
          ok) break ;;
          empty) echo -e "${RED}Input tidak boleh kosong!${RESET}" ;;
          notnumber) echo -e "${RED}Input harus berupa angka!${RESET}" ;;
          lessthanzero) echo -e "${RED}Nilai tidak boleh kurang atau sama dengan 0!${RESET}" ;;
      esac
  done


  # Perhitungan BMI
  hasil_bmi=$(hitung_bmi "$berat_kg" "$tinggi_cm")
  status=$(klasifikasi_bmi "$hasil_bmi")



#ouput Perhitungan
  echo -e "\n${GREEN}==========================="
  echo    "       Hasil Perhitungan     "
  echo -e "===========================${RESET}"

  echo -e "Berat Badan Anda : ${CYAN}$berat_kg kg${RESET}"
  echo -e "Tinggi Badan Anda : ${CYAN}$tinggi_cm cm${RESET}"
  echo -e "Nilai BMI : ${YELLOW}$hasil_bmi${RESET}"
  echo -e "Status : ${GREEN}$status${RESET}"

  echo -e "${GREEN}============================${RESET}"
}



#loopping menu program
while [ "$pilihan" != "2" ]; do
   tampilkan_menu
   read pilihan

   case $pilihan in
     1)
        proses_hitungan
        ;;
     2)
        echo -e "${GREEN}Terima Kasih Telah Menggunakan Program BMI Calculator${RESET}"
        ;;
     *)
        echo -e "${RED}Pilihan tidak valid, coba lagi (1-2)!${RESET}"
        ;;
   esac
done
