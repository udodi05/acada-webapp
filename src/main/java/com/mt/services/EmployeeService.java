package com.mt.services;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.ui.Model;
import com.mt.dao.EmployeeDAO;
import java.util.List;
import com.mt.models.Employee;

@Controller
@RequestMapping("/employee")
public class EmployeeService {

	
	@RequestMapping(value = "/getEmployeeDetails", method = RequestMethod.GET)
	public String getEmployeeDetails(Model model)
			throws JSONException {
		
		try {
			EmployeeDAO employeeDAO = new EmployeeDAO();
			List<Employee> employees = employeeDAO.findAll();
			model.addAttribute("employees", employees);
		} catch (Exception e) {
			model.addAttribute("error", "Failed to load employees: " + e.getMessage());
			e.printStackTrace();
		}
		
		return "employeeDetails";
	}
}


