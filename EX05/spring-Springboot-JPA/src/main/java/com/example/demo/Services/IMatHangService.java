package com.example.demo.Services;

import java.util.List;


import com.example.demo.Entity.MatHang;


public interface IMatHangService {
	List<MatHang> getList();
	MatHang getOneMatHang(String maHang);
	MatHang save(MatHang matHang);
	void delete(String maHang);
}
