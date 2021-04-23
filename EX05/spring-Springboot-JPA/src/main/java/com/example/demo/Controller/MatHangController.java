package com.example.demo.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.Entity.MatHang;
import com.example.demo.Services.IMatHangService;
import com.example.demo.payload.ResponseMessage;

@RestController
@RequestMapping("/api")
public class MatHangController {
	@Autowired
	IMatHangService service;
	@GetMapping("/NCC")
	public ResponseEntity<List<MatHang>> getList(){
		List<MatHang> list = service.getList();
		return ResponseEntity.status(HttpStatus.OK).body(list);
	}
	@GetMapping("/NCC/{maHang}")
	public ResponseEntity<MatHang> getOne(@PathVariable("maHang") String maHang) {
		MatHang matHang = service.getOneMatHang(maHang);
		return ResponseEntity.status(HttpStatus.OK).body(matHang);
	}
	@PostMapping("/NCC/insert")
	public ResponseEntity<ResponseMessage> createMatHang(@RequestBody MatHang mathang){
		ResponseMessage rm = new ResponseMessage();
		if(service.getOneMatHang(mathang.getMaHang()).getMaHang() == null){
			rm.setMatHang(service.save(mathang));
			rm.setMessage("Tạo thành công");
			
		}else{
			rm.setMessage("Tạo mới thất bại, mặt hàng đã có sẵn");
		}
		return ResponseEntity.status(HttpStatus.OK).body(rm);
	}
	@PutMapping("/NCC/update/{maHang}")
	public ResponseEntity<ResponseMessage> updateMatHang(@RequestBody MatHang matHang, @PathVariable("maHang") String maHang){
		ResponseMessage rm = new ResponseMessage();
		matHang.setMaHang(maHang);
		MatHang mH = service.save(matHang);
		if( mH == null ) {
			rm.setMessage("Cập Nhật Thất bại");
		}else {
			rm.setMessage("Cập Nhật Thành Công : === "+maHang);
			rm.setMatHang(mH);
		}
		return ResponseEntity.status(HttpStatus.OK).body(rm);
	}
	@DeleteMapping("/NCC/delete/{maHang}")
	public ResponseEntity<String> deleteByMaHang(@PathVariable("maHang") String maHang){
		String message;
		try {
			service.delete(maHang);
			message = "Xóa Thành Công "+maHang;
		} catch (Exception e) {
			message = "Xóa Thất Bại "+e;
		}
		return ResponseEntity.status(HttpStatus.OK).body(message);
	}
}
