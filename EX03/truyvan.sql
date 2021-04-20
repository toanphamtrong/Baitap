

/* 1. Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức là có cùng tên giao dịch) */
Select kh.makhachhang +' la doi tac cua '+ncc.tencongty from nhacungcap ncc inner join khachhang kh on ncc.tengiaodich = kh.tengiaodich

/* 2. Những đơn đặt hàng nào yêu cầu giao hàng ngay tại cty đặt hàng (đơn hàng được khách hàng order tại công ty)
và những đơn đó là của công ty nào?*/ 
Select 'Don hang '+CONVERT(nvarchar(10),ddh.sohoadon)+ ' duoc dat va giao tai '+ncc.tencongty as DONHANG 
from (dondathang ddh inner join khachhang kh on ddh.makhachhang = kh.makhachhang) , nhacungcap ncc 
where kh.tencongty = ncc.tencongty AND ddh.noigiaohang = ncc.diachi

SELECT dondathang.sohoadon,noigiaohang,khachhang.tencongty,tengiaodich
FROM dondathang INNER JOIN khachhang
ON khachhang.makhachhang = dondathang.makhachhang
WHERE khachhang.diachi = dondathang.noigiaohang
/* 3. Những mặt hàng nào chưa từng được khách hàng đặt mua */
Select * from mathang mh where mh.mahang not in(Select cth.mahang from chitietdathang cth inner join dondathang ddh on cth.sohoadon = ddh.sohoadon)

/* 4. Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?*/
Select * from nhanvien nv where nv.manhanvien not in(Select n.manhanvien from nhanvien n join dondathang dh on n.manhanvien = dh.manhanvien)
Select * from nhanvien nv where not exists(Select dh.manhanvien from dondathang dh where nv.manhanvien = dh.manhanvien)

/* 5. Trong năm 2020, những mặt hàng nào chỉ được đặt mua đúng một lần*/
Select mh.tenhang from (mathang mh inner join chitietdathang ctdh on mh.mahang = ctdh.mahang) join dondathang d on ctdh.sohoadon = d.sohoadon 
where YEAR(d.ngaydathang) = '2020'
group by mh.tenhang 
having COUNT(ctdh.mahang) =1

/* 6. Hãy cho biết mỗi một khách hàng đã phải bỏ ra bao nhiêu tiền để đặt mua hàng của công ty 
Số tiền mà mỗi khách hàng phải bỏ ra để mua hàng của công ty bán hàng đó. 
*/

Select kh.makhachhang, ctdh.giaban*ctdh.soluong*ctdh.mucgiamgia as so_tien, ctdh.mahang
from (khachhang kh  inner join dondathang ddh on kh.makhachhang = ddh.makhachhang) inner join chitietdathang ctdh on ctdh.sohoadon = ddh.sohoadon 
/*
where exists (select distinct ctd.mahang,ncc.tencongty from (chitietdathang ctd join mathang mh on ctd.mahang = mh.mahang) join nhacungcap ncc on ncc.macongty = mh.macongty)
*/
Select sum(tinhtong.so_tien) as 'Tong so tien', tinhtong.khach_hang from (Select kh.makhachhang khach_hang, (1-ctdh.mucgiamgia)*ctdh.soluong*ctdh.giaban as so_tien, ctdh.mahang ma_hang
from (khachhang kh  inner join dondathang ddh on kh.makhachhang = ddh.makhachhang) inner join chitietdathang ctdh on ctdh.sohoadon = ddh.sohoadon) as tinhtong
group by tinhtong.khach_hang

/*
7. Mỗi một nhân viên của công ty đã lập bao nhiêu đơn đặt hàng (nếu nhân viên chưa hề
lập một hoá đơn nào thì cho kết quả là 0)
*/
select nv.manhanvien, count(ddh.sohoadon) as so_hoa_don_da_lap 
from nhanvien nv left join dondathang ddh on nv.manhanvien = ddh.manhanvien
group by nv.manhanvien

/*
8. Cho biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2020 (thời
được gian tính theo ngày đặt hàng).
*/

Select (1-ctdh.mucgiamgia)*ctdh.soluong*ctdh.giaban, ctdh.mahang, mh.macongty, ddh.ngaydathang from (chitietdathang ctdh inner join dondathang ddh on ctdh.sohoadon = ddh.sohoadon) join mathang mh on mh.mahang = ctdh.mahang

Select sum(tinhtong.tong_tien) as 'Tong so tien', tinhtong.ma_cty, MONTH(tinhtong.ngaydathang) 'Thang'
from (Select (1-ctdh.mucgiamgia)*ctdh.soluong*ctdh.giaban as tong_tien, ctdh.mahang as ma_hang, mh.macongty as ma_cty, ddh.ngaydathang as ngaydathang
		from (chitietdathang ctdh inner join dondathang ddh on ctdh.sohoadon = ddh.sohoadon) join mathang mh on mh.mahang = ctdh.mahang) as tinhtong
group by tinhtong.ma_cty, MONTH(tinhtong.ngaydathang)

/*
9. Hãy cho biết tổng số lượng hàng của mỗi mặt hàng mà cty đã có (tổng số lượng hàng
hiện có và đã bán).
*/

select sum(ctdh.soluong) as Tong_so_luong_hang_da_ban ,sum(mh.soluong) as Tong_so_luong_hang_hien_co, ncc.tencongty 
from (mathang mh inner join chitietdathang ctdh on mh.mahang = ctdh.mahang) right join nhacungcap ncc on ncc.macongty = mh.macongty
group by ncc.tencongty


/*
10. Nhân viên nào của cty bán được số lượng hàng nhiều nhất và số lượng hàng bán được của nhân viên này là bao nhiêu?
*/
Select top  1 sum(ctdh.soluong) as tong, nv.ten from (chitietdathang ctdh inner join dondathang ddh on ctdh.sohoadon = ddh.sohoadon) join nhanvien nv on nv.manhanvien = ddh.manhanvien
group by nv.ten
order by tong desc


/*
11. Mỗi một đơn đặt hàng đặt mua những mặt hàng nào và tổng số tiền mà mỗi đơn đặt
hàng phải trả là bao nhiêu?
*/
Select distinct ctdh.sohoadon,  SUBSTRING((select ', '+ ct.mahang from chitietdathang ct where ctdh.sohoadon = ct.sohoadon order by ct.mahang  FOR XML PATH ('')),2,10) ,sum(ctdh.giaban*ctdh.soluong*ctdh.mucgiamgia) as 'Tong so tien' 
from chitietdathang ctdh 
group by ctdh.sohoadon

/*
12. Hãy cho biết mỗi một loại hàng bao gồm những mặt hàng nào, tổng số lượng hàng của
mỗi loại và tổng số lượng của tất cả các mặt hàng hiện có trong công ty là bao nhiêu?
*/
Select  lh.maloaihang , SUBSTRING((select ', '+ m.tenhang from mathang m where lh.maloaihang = m.maloaihang order by m.tenhang FOR XML PATH('')),2,1000) as cac_mat_hang,
(select sum(soluong) from mathang) as tong_sl_hien_co, sum(mh.soluong) as so_luong_mat_hang from loaihang lh join mathang mh on lh.maloaihang = mh.maloaihang
group by lh.maloaihang
order by lh.maloaihang

/*
13. Thống kê xem trong năm 2020, mỗi một mặt hàng trong mỗi tháng và trong cả năm bán
được với số lượng bao nhiêu
*/
Select ctdh.mahang , sum(ctdh.soluong) as so_luong_ban, MONTH(ddh.ngaydathang) as Thang,
(Select sum(ct.soluong) from chitietdathang ct join dondathang d on ct.sohoadon = d.sohoadon where ct.mahang = ctdh.mahang group by ct.mahang ) as Tong_so_luong_ban_duoc_trong_nam_2020
from chitietdathang ctdh join dondathang ddh on ctdh.sohoadon = ddh.sohoadon
where YEAR(ddh.ngaydathang) = 2020 
group by ctdh.mahang, MONTH(ddh.ngaydathang)
order by  ctdh.mahang


/*
14. Cập nhật lại giá trị NGAYCHUYENHANG của những bản ghi có giá trị
NGAYCHUYENHANG chưa xác định (NULL) trong bảng DONDATHANG bằng với giá
trị của trường NGAYDATHANG.
*/
Update dondathang set ngaychuyenhang = ngaydathang
where ngaychuyenhang is null;

/*
15. Cập nhật giá trị của trường NOIGIAOHANG trong bảng DONDATHANG bằng địa chỉ
của khách hàng đối với những đơn đặt hàng chưa xác định được nơi giao hàng (có giá
trị trường NOIGIAOHANG bằng NULL)
*/
Update dondathang  set noigiaohang = kh.diachi 
from dondathang  ddh join khachhang kh on ddh.makhachhang = kh.makhachhang
where noigiaohang is null or noigiaohang = '';

/*
 16. Cập nhật lại dữ liệu trong bảng KHACHHANG sao cho nếu tên công ty và tên giao dịch
của khách hàng trùng với tên công ty và tên giao dịch của một nhà cung cấp nào đó thì
địa chỉ, điện thoại, fax và email phải giống nhau
*/
Update khachhang set diachi = ncc.diachi, dienthoai = ncc.dienthoai, fax = ncc.fax, email = ncc.email
from khachhang kh, nhacungcap ncc
where kh.tencongty = ncc.tencongty and kh.tengiaodich = ncc.tengiaodich;

/*
17. Tăng lương lên gấp rưỡi cho những nhân viên bán được số lượng hàng nhiều hơn 2
trong năm 2020
*/
Update nhanvien set luongcoban = (luongcoban *1.5)
where manhanvien in 
(	select nv.manhanvien 
	from (nhanvien nv inner join dondathang ddh on nv.manhanvien = ddh.manhanvien) join chitietdathang ctd on ctd.sohoadon = ddh.sohoadon 
	group by nv.manhanvien
	having sum(ctd.soluong) > 2
)

/*
18. Tăng phụ cấp lên bằng 50% lương cho những nhân viên bán được hàng nhiều nhất.
1-- tính tổng số lượng hàng bán được của nhân viên
2-- tìm giá trị tổng số lượng lớn nhất
3-- so sánh
*/

select ddh.manhanvien as nhanvien, sum(ctd.soluong) as tong_so_luong_ban
	from dondathang ddh join chitietdathang ctd on ctd.sohoadon = ddh.sohoadon
	group by  ddh.manhanvien
	order by sum(ctd.soluong) desc

select max(nv.tong_so_luong_ban) from (select ddh.manhanvien as nhanvien, sum(ctd.soluong) as tong_so_luong_ban
	from dondathang ddh join chitietdathang ctd on ctd.sohoadon = ddh.sohoadon
	group by  ddh.manhanvien) as nv


Update nhanvien set phucap = (luongcoban*0.5 )
where manhanvien in 
(	select nv1.nhanvien from 
		(select ddh.manhanvien as nhanvien, sum(ctd.soluong) as tong_so_luong_ban
		from dondathang ddh join chitietdathang ctd on ctd.sohoadon = ddh.sohoadon
		group by  ddh.manhanvien) as nv1, 
		(select max(nv.tong_so_luong_ban) as lon_nhat from (select ddh.manhanvien as nhanvien, sum(ctd.soluong) as tong_so_luong_ban
		from dondathang ddh join chitietdathang ctd on ctd.sohoadon = ddh.sohoadon
		group by  ddh.manhanvien) as nv) as nv2
	where nv2.lon_nhat = nv1.tong_so_luong_ban )

/*
19. Giảm 25% lương của những nhân viên trong năm 2020 ko lập được bất kỳ đơn đặt
hàng nào
*/
update nhanvien set luongcoban = (luongcoban - luongcoban*0.25)
where manhanvien not in (select distinct nv.manhanvien from nhanvien nv join dondathang ddh on nv.manhanvien =ddh.manhanvien)

/*
20 Giả sử trong bảng DONDATHANG có them trường SOTIEN cho biết số tiền mà khách
hàng phải trả trong mỗi dơn đặt hàng. Hãy tính giá trị cho trường này.
*/
alter table dondathang add sotien money

update dondathang set sotien = (1-mucgiamgia)*giaban*soluong 
from dondathang ddh join chitietdathang ctdh on ddh.sohoadon = ctdh.sohoadon

------Xoá khỏi bảng MATHANG những mặt hàng có số lượng bằng 0 và không được đặt mua trong bất kỳ đơn đặt hàng nào.*/

Delete from MATHANG 
where soluong = 0 or mahang not in (select distinct mh.mahang from mathang mh join chitietdathang ctdh on mh.mahang = ctdh.mahang);

/*
1. Tạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung thêm một bản ghi mới cho
bảng MATHANG (thủ tục phải thực hiện kiểm tra tính hợp lệ của dữ liệu cần bổ sung:
không trùng khoá chính và đảm bảo toàn vẹn tham chiếu)
*/

CREATE PROC addMathang(
-- Khai báo các tham số truyền vào 
	@mahang nvarchar(10) ,
	@tenhang nvarchar(50) ,
	@macongty nvarchar(10) null,
	@maloaihang int null,
	@soluong int null,
	@donvitinh nvarchar(20) null,
	@giahang money null)
AS
	-- kiểm tra việc trùng khóa chính
	IF not exists (select mahang from mathang where mahang =@mahang)
	-- khóa ngoại macongty, maloaihang có thể null hoặc bằng giá trị tham số truyền vào
	IF (@macongty is null or exists (select macongty from nhacungcap where macongty=@macongty))
	IF (@maloaihang is null or exists(select maloaihang from loaihang where maloaihang=@maloaihang))
	insert into mathang values(@mahang,@tenhang,@macongty,@maloaihang,@soluong,@donvitinh,@giahang);

	exec addMathang 'mh13','Pin 200W',null,null,19,'VND',200000;
	Select * from mathang


/*
2. Tạo thủ tục lưu trữ có chức năng thống kê tổng số lượng hàng bán được của một mặt
hàng có mã bất kỳ (mã mặt hàng cần thống kê là tham số của thủ tục).
*/

Select mh.mahang, mh.tenhang, sum(ctd.soluong) as Tong_so_luong from mathang mh inner join chitietdathang ctd on mh.mahang = ctd.mahang
		where mh.mahang = 'mh1'
		group by mh.mahang, mh.tenhang

CREATE PROC thong_ke_so_luong(@mahang nvarchar(10))
AS	
	BEGIN
		Select mh.mahang, mh.tenhang, sum(ctd.soluong) as Tong_so_luong
		from mathang mh inner join chitietdathang ctd on mh.mahang = ctd.mahang
		where mh.mahang = @mahang
		group by mh.mahang, mh.tenhang
	END;

	exec thong_ke_so_luong 'mh2';


/*
3. Viết trigger cho bảng CHITIETDATHANG theo yêu cầu sau:
 -- Khi một bản ghi mới được bổ sung vào bảng này thì giảm số lượng hàng hiện có 
 nếu số lượng hàng hiện có lớn hơn hoặc bằng số lượng hàng được bán ra. Ngược lại thì
huỷ bỏ thao tác bổ sung.
*/

CREATE TRIGGER edit_donhang ON chitietdathang FOR INSERT
AS
	BEGIN
		declare @mahang nvarchar(10)
		declare @soluongban smallint
		declare @soluongconlai smallint
		select @mahang = inserted.mahang, @soluongban =	inserted.soluong from inserted
		select @soluongconlai= mathang.soluong from mathang where mathang.mahang=@mahang
		if @soluongconlai >= @soluongban -- mahang.soluong > soluong insert vào bảng chitietdathang
		-- số lượng của mặt hàng sẽ giảm nếu ta insert vao bang chitietdathang
		update mathang set mathang.soluong= mathang.soluong - @soluongban
		where mathang.mahang=@mahang
		
	END;

	insert into chitietdathang values(2,'mh11',6200000,2,0.15)
	Select * from chitietdathang
	Select * from mathang

 /*-- Khi cập nhật lại số lượng hàng được bán, kiểm tra số lượng hàng được cập nhật lại có
phù hợp hay không (số lượng hàng bán ra không được vượt quá số lượng hàng hiện
có và không được nhỏ hơn 1). Nếu dữ liệu hợp lệ thì giảm (hoặc tăng) số lượng hàng
hiện có trong công ty, ngược lại thì huỷ bỏ thao tác cập nhật.
*/

CREATE TRIGGER update_donhang ON chitietdathang FOR UPDATE
AS
	if update(soluong)
		BEGIN
			if exists(select sohoadon from inserted where soluong<0)
			rollback transaction
			else       
				BEGIN
			update mathang set soluong = soluong - (select sum(inserted.soluong - deleted.soluong)
				from inserted INNER JOIN deleted on inserted.sohoadon = deleted.sohoadon AND inserted.mahang = deleted.mahang
				where inserted.mahang=mathang.mahang
				group by inserted.mahang)
			where mahang in (select DISTINCT mahang from inserted)
	if exists(select mahang from mathang where soluong < 0)
		rollback transaction
				END;
		END;

select * from loaihang
Select * from nhacungcap
Select * from khachhang
Select * from chitietdathang
Select * from mathang
select * from dondathang	
select * from nhanvien

/*
4. Viết trigger cho bảng CHITIETDATHANG để sao cho chỉ chấp nhận giá hàng bán ra
phải nhỏ hơn hoặc bằng (<=) giá gốc (giá của mặt hàng trong bảng MATHANG)
*/
CREATE TRIGGER banhang ON chitietdathang
FOR INSERT,UPDATE
AS
	IF UPDATE(giaban)
	IF exists(select inserted.mahang from mathang INNER JOIN inserted on mathang.mahang = inserted.mahang where inserted.giaban <= mathang.giahang )
	rollback transaction