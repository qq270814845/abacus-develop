#ifndef DIAGO_LCAO_MATRIX_H
#define DIAGO_LCAO_MATRIX_H

#include "../module_base/global_function.h"
#include "../module_base/global_variable.h"
#include "../module_base/matrix.h"
#include "../module_base/complexmatrix.h"
#include "src_lcao/LCAO_matrix.h"
#include "src_lcao/local_orbital_wfc.h"

class Diago_LCAO_Matrix
{
	public:
	Diago_LCAO_Matrix(LCAO_Matrix* lm);
	~Diago_LCAO_Matrix();

	//void solve_double_matrix(const int &ik, double **wfc, ModuleBase::matrix &wfc_2d)const;
	void solve_double_matrix(const int &ik, Local_Orbital_wfc &lowf)const; //LiuXh add 2021-09-06, clear memory, totwfc not used now
	void solve_complex_matrix(const int &ik, Local_Orbital_wfc &lowf)const;

private:
    
    LCAO_Matrix* LM;

	void using_LAPACK(const int &ik, double **wfc)const;
	void using_LAPACK_complex(const int &ik, std::complex<double> **wfc)const;
	void using_CG(const int &ik, double **c)const;

#ifdef __MPI
	//void using_HPSEPS_double(const int &ik, double **wfc, ModuleBase::matrix &wfc_2d)const;
	void using_HPSEPS_double(const int &ik, Local_Orbital_wfc &lowf)const; //LiuXh add 2021-09-06, clear memory, totwfc not used now
	void using_HPSEPS_complex(const int &ik, Local_Orbital_wfc &lowf)const;
#endif

};

#endif
