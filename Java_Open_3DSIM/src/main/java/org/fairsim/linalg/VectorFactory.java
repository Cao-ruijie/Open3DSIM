

package org.fairsim.linalg;

/** Classes implementing this interface provide means of creating 
 * vector objects.
 * By calling the corresponting methods, a vector of a given
 * size and dimensionality is created by the factory. This
 * should e.g. be used when creating vectors that live in
 * native code or on an accel. card (GPU, etc.).
 **/
public abstract class VectorFactory {

    /** Return a one-dimensional, real-valued vector, with n elements. */
    public abstract Vec.Real createReal(int n);
    
    /** Return a one-dimensional, complex-valued vector, with n elements. */
    public abstract Vec.Cplx createCplx(int n);
   
    
    /** Return a two-dimensional, real-valued vector, sized w x h. */
    public abstract Vec2d.Real createReal2D(int w, int h);
    
    /** Return a two-dimensional, complex-valued vector, sized w x h. */
    public abstract Vec2d.Cplx createCplx2D(int w, int h);
    
    /** Return a two-dimensional, real-valued vector, sized w x h x d. */
    public abstract Vec3d.Real createReal3D(int w, int h, int d);
    
    /** Return a two-dimensional, complex-valued vector, sized w x h x d. */
    public abstract Vec3d.Cplx createCplx3D(int w, int h, int d);


    // --- one-dimensional arrays ---

    /** Returns a one-dimensional array of 1D Real Vectors */
    public Vec.Real [] createArrayReal(int s, int n) {
	Vec.Real [] ret = new Vec.Real[s];
	for (int i=0; i<s; i++)
	    ret[i] = createReal(n);
	return ret;
    }

    /** Returns a one-dimensional array of 1D Cplx Vectors */
    public Vec.Cplx [] createArrayCplx(int s, int n) {
	Vec.Cplx [] ret = new Vec.Cplx[s];
	for (int i=0; i<s; i++)
	    ret[i] = createCplx(n);
	return ret;
    }

    /** Returns a one-dimensional array of 2D Real Vectors */
    public Vec2d.Real [] createArrayReal2D(int s, int w, int h) {
	Vec2d.Real [] ret = new Vec2d.Real[s];
	for (int i=0; i<s; i++)
	    ret[i] = createReal2D(w,h);
	return ret;
    }

    /** Returns a one-dimensional array of 2D Cplx Vectors */
    public Vec2d.Cplx [] createArrayCplx2D(int s, int w, int h) {
	Vec2d.Cplx [] ret = new Vec2d.Cplx[s];
	for (int i=0; i<s; i++)
	    ret[i] = createCplx2D(w,h);
	return ret;
    }

    // --- two-dimensional arrays ---

    /** Returns a two-dimensional array of 1D Real Vectors */
    public Vec.Real [][] createArrayReal(int s, int t, int n) {
	Vec.Real [][] ret = new Vec.Real[s][t];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	    ret[i][j] = createReal(n);
	return ret;
    }

    /** Returns a two-dimensional array of 1D Cplx Vectors */
    public Vec.Cplx [][] createArrayCplx(int s, int t, int n) {
	Vec.Cplx [][] ret = new Vec.Cplx[s][t];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	    ret[i][j] = createCplx(n);
	return ret;
    }

    /** Returns a two-dimensional array of 2D Real Vectors */
    public Vec2d.Real [][] createArrayReal2D(int s, int t, int w, int h) {
	Vec2d.Real [][] ret = new Vec2d.Real[s][t];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	    ret[i][j] = createReal2D(w,h);
	return ret;
    }

    /** Returns a two-dimensional array of 2D Cplx Vectors */
    public Vec2d.Cplx [][] createArrayCplx2D(int s, int t, int w, int h) {
	Vec2d.Cplx [][] ret = new Vec2d.Cplx[s][t];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	    ret[i][j] = createCplx2D(w,h);
	return ret;
    }

    // --- three-dimensional arrays ---

    /** Returns a three-dimensional array of 1D Real Vectors */
    public Vec.Real [][][] createArrayReal(int s, int t, int u, int n) {
	Vec.Real [][][] ret = new Vec.Real[s][t][u];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	for (int k=0; k<u; k++)
	    ret[i][j][k] = createReal(n);
	return ret;
    }

    /** Returns a three-dimensional array of 1D Cplx Vectors */
    public Vec.Cplx [][][] createArrayCplx(int s, int t, int u,int n) {
	Vec.Cplx [][][] ret = new Vec.Cplx[s][t][u];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	for (int k=0; k<u; k++)
	    ret[i][j][k] = createCplx(n);
	return ret;
    }

    /** Returns a three-dimensional array of 2D Real Vectors */
    public Vec2d.Real [][][] createArrayReal2D(int s, int t, int u, int w, int h) {
	Vec2d.Real [][][] ret = new Vec2d.Real[s][t][u];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	for (int k=0; k<u; k++)
	    ret[i][j][k] = createReal2D(w,h);
	return ret;
    }

    /** Returns a three-dimensional array of 2D Cplx Vectors */
    public Vec2d.Cplx [][][] createArrayCplx2D(int s, int t, int u, int w, int h) {
	Vec2d.Cplx [][][] ret = new Vec2d.Cplx[s][t][u];
	for (int i=0; i<s; i++)
	for (int j=0; j<t; j++)
	for (int k=0; k<u; k++)
	    ret[i][j][k] = createCplx2D(w,h);
	return ret;
    }




    
    /** Finish whatever parallel / concurrent process is running (for timing CUDA, etc.) */
    public abstract void syncConcurrent();

}


