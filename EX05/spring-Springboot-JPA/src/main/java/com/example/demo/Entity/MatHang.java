package com.example.demo.Entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "mathang")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class MatHang{
	
	@Id
	@Column( name = "mahang", length = 10)
	private String maHang;
	@Column( name = "tenhang", length =50)
	private String tenHang;
	@Column( name = "macongty", length = 10)
	private String maCongTy;
	@Column( name = "maloaihang")
	private int maLoaiHang;
	@Column( name = "soluong")
	private int soLuong;
	@Column( name = "donvitinh")
	private String donViTinh;
	@Column( name = "giahang")
	private double giaHang;
}
