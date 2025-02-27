*************************************************
*     Calculate the Lindard response function 
*************************************************
      module value
      implicit double precision (a-h,o-z)      
      real(8), parameter :: Pi=3.14159 
      real(8), parameter :: xmu=3.33             ! chemical potential 
      real(8), parameter :: xm=5                 ! Dirac mass
      real(8), parameter :: xi=100               ! in-plane band inversion parameter
      real(8), parameter :: xiz=200              ! z-direction band inversion parameter
      real(8), parameter :: v=393.75             ! in-plane Fermi velocity 
      real(8), parameter :: vz=0                 ! z-direction Fermi velocity      
      real(8), parameter :: xmuB=0.05788         ! Bohr magneton 
      real(8), parameter :: xB=6.5               ! magnetic field
      real(8), parameter :: xlB=25.6/sqrt(xB)    ! magnetic length 
      real(8), parameter :: deg=2*Pi*xlB*xlB     ! degeneracy factor   
      real(8), parameter :: g1=-8                ! Zeeman parameter1
      real(8), parameter :: g2=10                ! Zeeman parameter2
      real(8), parameter :: eta=0.01             ! linewidth parameter 
cc      
      end module value
cc      
**********************
*     main program
**********************
      program main
	use value
      implicit double precision (a-h,o-z)
      character(100) filename 
      write(filename,'(a100)') 'results.dat'
      open(10,file=filename)        
cc
      do 100 q=0.001,0.4,0.001     
cc       
cc    Case1: alpha=1,beta=1 
      chi1=0 
      do zk1=-0.5,0.5001,0.001
cc    do zk1=-0.5,0,0.001    
         zk2=zk1+q
         if(zk2>0.5) zk2=zk2-1 
         call solve_em(em1,zk1)
         call solve_em(em2,zk2)
         Nf1=0
         Nf2=0
         if(em1<xmu) Nf1=1
         if(em2<xmu) Nf2=1
         aa=em1-em2
         chi1=chi1+aa*(Nf1-Nf2)/(aa*aa+eta*eta)
      end do
             
cc    Case2: alpha=2,beta=2 
      chi2=0
      do zk1=-0.5,0.5001,0.001
cc    do zk1=-0.5,0,0.001      
         zk2=zk1+q
         if(zk2>0.5) zk2=zk2-1 
         call solve_ep(ep1,zk1)
         call solve_ep(ep2,zk2)
         Nf1=0
         Nf2=0
         if(ep1<xmu) Nf1=1
         if(ep2<xmu) Nf2=1
         aa=ep1-ep2
         chi2=chi2+aa*(Nf1-Nf2)/(aa*aa+eta*eta)
      end do             
cc
cc    Case3: alpha=1,beta=2
      chi3=0 
      do zk1=-0.5,0.5001,0.001
cc    do zk1=-0.5,0,0.001      
         zk2=zk1+q
         if(zk2>0.5) zk2=zk2-1 
         call solve_ep(ep,zk1)         
         call solve_em(em,zk2)
         Nf1=0
         Nf2=0
         if(ep<xmu) Nf1=1         
         if(em<xmu) Nf2=1
         aa=ep-em
         chi3=chi3+aa*(Nf1-Nf2)/(aa*aa+eta*eta) 
      end do  
cc
cc    Case4: alpha=2,beta=1
      chi4=0
      do zk1=-0.5,0.5001,0.001
cc    do zk1=0,0.5,0.001    
         zk2=zk1+q
         if(zk2>0.5) zk2=zk2-1 
         call solve_em(em,zk1)
         call solve_ep(ep,zk2)
         Nf1=0
         Nf2=0
         if(em<xmu) Nf1=1
         if(ep<xmu) Nf2=1
         aa=em-ep
         chi4=chi4+aa*(Nf1-Nf2)/(aa*aa+eta*eta)
      end do
cc    
      chi1=-chi1/(1000*deg)
      chi2=-chi2/(1000*deg)
      chi3=-chi3/(1000*deg)
      chi4=-chi4/(1000*deg) 
      chi=chi1+chi2+chi3+chi4 
      write(10,'(100f16.8)') q,chi,chi1,chi2,chi3,chi4
100   continue
cc      
      end program main
cc      
***************************
*     n=0, lambda=-1 LL
***************************
      subroutine solve_em(em,zk)
      use value
      implicit double precision (a-h,o-z)
cc
      aa=xm-xiz*zk*zk-xi/(xlB*xlB)+xmuB*xB*g1/2
      em=aa+xmuB*xB*g2/2
cc
      end subroutine solve_em
cc      
**************************
*     n=0, lambda=1 LL
**************************
      subroutine solve_ep(ep,zk)
      use value
      implicit double precision (a-h,o-z)
cc   
      aa=xm-xiz*zk*zk-xi/(xlB*xlB)+xmuB*xB*g1/2
      ep=-aa+xmuB*xB*g2/2 
cc
      end subroutine solve_ep
cc