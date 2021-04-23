package com.example.demo.payload;

import com.example.demo.Entity.MatHang;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ResponseMessage {
	private String message;
	private MatHang matHang;
	public ResponseMessage(String message) {
		this.message = message;
	}
}
