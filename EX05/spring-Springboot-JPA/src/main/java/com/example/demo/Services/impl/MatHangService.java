package com.example.demo.Services.impl;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.Entity.MatHang;
import com.example.demo.Repository.MatHangRepository;
import com.example.demo.Services.IMatHangService;

@Service
public class MatHangService implements IMatHangService{
	@Autowired
	MatHangRepository repository;
	@Override
	public List<MatHang> getList() {
		List<MatHang> list;
		list = repository.findAll();
		return list;
	}
	@Override
	public MatHang getOneMatHang(String maHang) {
		return repository.findById(maHang).orElse(new MatHang());
	}
	@Override
	public MatHang save(MatHang matHang) {
		return repository.save(matHang);
	}
	@Override
	public void delete(String maHang) {
		repository.deleteById(maHang);
		
	}

}
