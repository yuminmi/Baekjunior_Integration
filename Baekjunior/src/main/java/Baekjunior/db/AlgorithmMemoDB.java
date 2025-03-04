package Baekjunior.db;

import java.sql.*;
import javax.naming.NamingException;
import Baekjunior.db.DsCon;

public class AlgorithmMemoDB {
	private Connection con;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public AlgorithmMemoDB() throws NamingException, SQLException {
		con = DsCon.getConnection();
	}
	
	public int algorithmExistCheck(String user_id, String algorithm_name) throws SQLException {
		String sql = "SELECT * FROM algorithm_memo WHERE user_id=? AND algorithm_name=?";
		
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, user_id);
		pstmt.setString(2, algorithm_name);
		rs = pstmt.executeQuery();
		if(rs.next()) {
			return 1;
		}
		return 0;
	}
	
	public void insertAlgorithmMemo(String user_id, String algorithm_name) throws SQLException {
		String sql = "INSERT INTO algorithm_memo (user_id, algorithm_name) VALUES (?, ?)";
		
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, user_id);
		pstmt.setString(2, algorithm_name);
		
		pstmt.executeUpdate();
	}
	
	public void updateAlgorithmMemo(AlgorithmMemo am) throws SQLException {
		String sql = "UPDATE algorithm_memo SET algorithm_memo=? WHERE user_id=? AND algorithm_name=?";
		
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, am.getAlgorithm_memo());
		pstmt.setString(2, am.getUser_id());
		pstmt.setString(3, am.getAlgorithm_name());
		
		pstmt.executeUpdate();
	}
	
	public int countAlgorithmMemo(String id) throws SQLException {
		String sql = "SELECT COUNT(*) FROM algorithm_memo WHERE user_id=?";
		
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, id);
		rs = pstmt.executeQuery();
		if(rs.next()) {
			return rs.getInt(1);
		}
		return 0;
	}
	
	// 카테고리를 삭제하는 함수
	public void deleteAlgorithm(int cate_idx) throws SQLException {
		String sql = "DELETE FROM algorithm_memo WHERE idx=?";
			
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, cate_idx);
			
		pstmt.executeUpdate();
		pstmt.close();
	}
	
	public void close() throws SQLException {
		if(rs != null) rs.close();
		if(pstmt != null) pstmt.close();
		if(con != null) con.close();
	}
}
